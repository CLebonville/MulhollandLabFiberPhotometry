################################################
############ JOINT SPLINES FUNCTION ############
################################################

# Code developed by Chris McMahan, PhD, Clemson University
##Must set working directory to the location of the MATLAB functions where to_rA and to_rB will be deposited upon running the loop. Use R
##notation with "/" instead of "\" in the path. 
setwd("Z:/Christina Lebonville/2020.06.16 (CL8 or DRK-MK) CeA Dyn Fiber Recording in DID/Scripts and Functions Used R MATLAB PYTHON/")
#setwd("H:/Desktop/2022.10.10 (CL20) CeA Dyn FP in Drinking Hedonics (CL20)/MATLAB Functions Used/")

library(R.matlab)
library(splines)
library(Matrix)
library(splines2)


data <- readMat('to_r.mat')
data.ref<-data$raw.405
data.sig<-data$raw.470

N<-length(data.ref)
T<-c(seq(1,N,by=200),N)

n<-length(T)

# Structuring the response and predictor variables
Yr<-data.ref[T]
Ys<-data.sig[T]
T<-T/max(T)
Y<-c(Yr,Ys)


#fitref<-lm(Yr~T)
#fitsig<-lm(Ys~T)
#Yr<-Yr-fitref$fitted.values
#Ys<-Ys-fitsig$fitted.values


df<-150
degree<-3
nint<-df-degree
b.knots<-c(min(T),max(T))
knots<-quantile(T,prob=seq(0,1,length.out=(nint+2))[-c(1,nint+2)])

Bs <-as.matrix(bs(T,knots=knots, Boundary.knots=b.knots,degree=degree,intercept=FALSE))
Xs<-cbind(1,T,Bs)
X<-kronecker(diag(rep(1,2)), Xs, FUN = "*")

# Structuring the penalty matrix

Js<-matrix(-99,nrow=df,ncol=df)
for(i in 1:df){
  for(j in 1:df){
    temp<-Bs[,i]*Bs[,j]
    Js[i,j]<-sum((temp[-1]+temp[-(n)])/2*(T[-1]-T[-n]))  
  }}

Js<-cbind(0,0,rbind(0,0,Js))  # Penalizes toward "functional similarity"
J<-cbind(rbind(Js,Js),rbind(Js,Js))

Rs<-diag(c(0,0,rep(1,df)))

R<-kronecker(diag(rep(1,2)), Rs, FUN = "*")   # For ridge penalty to insure identifiability
I<-diag(rep(1,df))

Ds<-I-cbind(0,I[,-df])
Ds<-Ds[-df,]
Ds<-cbind(0,0,Ds)
Ds<-t(Ds)%*%Ds
D<-kronecker(diag(rep(1,2)), Ds, FUN = "*")


lam.can<-expand.grid(seq(1,500000,100000),seq(1,100,10),seq(1,200,10))
#lam.can<-expand.grid(seq(1,500,5),1,50)

# pre-compute to speed
XTX<-t(X)%*%X
XTY<-t(X)%*%Y


BIC<-rep(-99,dim(lam.can)[1])
for(i in 1: dim(lam.can)[1]){
  
  lam1<-lam.can[i,1]
  lam2<-lam.can[i,2]
  lam3<-lam.can[i,3]
  
  XTXi<-solve(XTX+lam1*J + lam2*R + lam3*D)
  
  S.lam<-XTXi%*%XTX    # Smoother matrix
  
  bhat<-XTXi%*%XTY
  Y.hatr<-Xs%*%bhat[1:(df+2)]
  Y.hats<-Xs%*%bhat[(df+3):(2*df+4)]
  
  
  edf<-sum(diag(S.lam))
  SSEr<- sum((Yr-Y.hatr)^2)/(n)
  SSEs<- sum((Ys-Y.hats)^2)/(n)
  BIC[i]<-n*log(SSEr)+n*log(SSEs)+log(n)*edf
  print(i)
}

lam.i<-which(BIC==min(BIC))

lam1<-lam.can[lam.i,1]
lam2<-lam.can[lam.i,2]
lam3<-lam.can[lam.i,3]

bhat<-solve(XTX + lam1*J + lam2*R + lam3*D)%*%XTY

par(mfrow=c(2,1))
plot(T,Yr)
lines(T,Xs%*%bhat[1:(df+2)],col="red")

plot(T,Ys)
lines(T,Xs%*%bhat[(df+3):(2*df+4)],col="red")



df<-150
degree<-3
nint<-df-degree
b.knots<-c(min(T),max(T))
knots<-quantile(T,prob=seq(0,1,length.out=(nint+2))[-c(1,nint+2)])

DT.r<-NULL

step<-50000
iter<-ceiling(N/step)

for(i in 1:iter){
  
  lower<-step*(i-1)+1
  upper<-step*i
  upper<-min(upper,N)
  Ta<-(lower:upper)/N
  Bsa <-as.matrix(bs(Ta,knots=knots, Boundary.knots=b.knots,degree=degree,intercept=FALSE))
  Ya.r<-data.ref[lower:upper]
  Xar<-cbind(1,Ta,Bsa)
  #temp<-Ya.r-Xar%*%bhat[1:(df+2)]
  temp<-Xar%*%bhat[1:(df+2)]
  DT.r<-c(DT.r,temp)
  print(i)
}

#f01A<-DT.r
#RSr<-data.ref
#RSs<-data.sig

#rm(list=ls()[! ls() %in% c("f01","RSr","RSs")])


#Save and clear
writeMat("JOINT_sig.mat", JointOut = DT.r)

#rm(list=ls()[! ls() %in% c("data")])

