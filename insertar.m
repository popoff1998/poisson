%% cargamos las imagenes
M=imread('mascara.bmp');
F=imread('fuente.jpg');
D=imread('destino.jpg');

%% Datos para desplazarnos por las matrices
[nfilas,ncolumnas]=size(M);
destFila=44;     
destColumna=482;
% (destFila,destColumna)  --> Pto en el que empezaremos a copiar la imagen

%% Insertamos la imagen fuente en la destino
D=double(D);
for i=1:nfilas
    for j=1:ncolumnas
        if(M(i,j)==255)
          D(destFila+i-1,destColumna+j-1,1)=F(i,j,1);
          D(destFila+i-1,destColumna+j-1,2)=F(i,j,2);
          D(destFila+i-1,destColumna+j-1,3)=F(i,j,3);
        end  
    end
end
D=uint8(D);

%% Volcacamos la matriz a un fichero fisico
imwrite(D,'insertar.bmp');
