%cargamos la imagen
M=imread('mascara.bmp');
D=imread('uco.jpg');
F=imread('rinoceronte.jpg');
C=imread('correcion.bmp');

X=D;  %sera la imagen con la que trabajaremos
[nfilas,ncolumnas]=size(M);
k=1;   %los usaremos para recorrer la mascara
l=0;

X=double(X);


for i=256:256+nfilas-1
    l=l+1;
    k=1;
    for j=345:345+ncolumnas-1
    if(M(l,k)==255)
       X(i,j,1)=F(l,k,1)+C(l,k,1);
       X(i,j,2)=F(l,k,2)+C(l,k,2);
       X(i,j,3)=F(l,k,3)+C(1,k,3);
    end  
       k=k+1;
    end
end

X=uint8(X);


%pasamos la matriz a una imagen fisica
imwrite(X,'final.jpg');