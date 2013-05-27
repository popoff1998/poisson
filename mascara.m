%% Cargamos la imagen y tomamos datos para movernos por la matriz
F=imread('mascara_beta.png');
[nfilas,ncolumnas,nprofundidad]=size(F);
M=zeros(nfilas,ncolumnas);

%% Creamos la mascara
for i=1:nfilas-1
    for j=1:ncolumnas-1
      if((F(i,j,1)==255)&&(F(i,j,2)==255)&&(F(i,j,3)==255))
        M(i,j)=0;
      else
          M(i,j)=255;
      end
    end
end

%% Volcacamos la matriz a un fichero fisico
imwrite(M,'mascara.bmp');