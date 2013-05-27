%% Cargamos las imagenes
M=imread('mascara.bmp');
F=imread('fuente.jpg');
D=imread('destino.jpg');

[nfilas,ncolumnas]=size(M); %tama�o de la mascara

%% Creamos la matriz de adyacencias

A=zeros(nfilas,ncolumnas);
pixel=0; %numero de pixeles blancos de la mascara
for i=1:nfilas
    for j=1:ncolumnas
        if(M(i,j)==255)            
            pixel=pixel+1;
            A(i,j)=pixel;
        end
    end
end

%% Creamos los 3 sistemas a resolver (RGB)
    S=sparse(pixel,pixel);  %matriz de coeficientes
        R1=sparse(pixel,1);     %vectores con los term indep     
        R2=sparse(pixel,1);
        R3=sparse(pixel,1);

        F1=sparse(pixel,1);     %vectores con las soluciones
        F2=sparse(pixel,1);
        F3=sparse(pixel,1);
            
      
%% Datos para desplazarnos por las matrices

 blancos=1;

 %{
 %Para el rinoceronte
 destFila=256;
 destColumna=345;
%}
%Para el avion
 destFila=500;
 destColumna=482; 
 

%% Creamos el sistema de ecuaciones

for i=2:nfilas-1
    dx=destFila+i-1;
    dy=destColumna;
    for j=2:ncolumnas-1
        dy=destColumna+j-1;
        
        if(M(i,j)==255)
   
            S(blancos,blancos)=1;
            suma1=0;
            suma2=0;
            suma3=0;
          
              %primer adyacente
            if(M(i,j+1)==0)
                suma1=suma1+D(dx,dy+1,1)-F(i,j+1,1);
                suma2=suma2+D(dx,dy+1,2)-F(i,j+1,2);
                suma3=suma3+D(dx,dy+1,3)-F(i,j+1,3);

            else
                S(blancos,A(i,j+1))=-1/4;
            end   
            
            %segundo adyacencia
             if(M(i,j-1)==0)
              
                suma1=suma1+D(dx,dy-1,1)-F(i,j-1,1);
                suma2=suma2+D(dx,dy-1,2)-F(i,j-1,2);
                suma3=suma3+D(dx,dy-1,3)-F(i,j-1,3);

            else
                S(blancos,A(i,j-1))=-1/4;
            end   
            
            %tercer adyacente
            if(M(i-1,j)==0)
                suma1=suma1+D(dx-1,dy,1)-F(i-1,j,1);
                suma2=suma2+D(dx-1,dy,2)-F(i-1,j,2);
                suma3=suma3+D(dx-1,dy,3)-F(i-1,j,3);

            else
                S(blancos,A(i-1,j))=-1/4;
            end
            
            %cuarto adyacente
            if(M(i+1,j)==0)
                suma1=suma1+D(dx+1,dy,1)-F(i+1,j,1);
                suma2=suma2+D(dx+1,dy,2)-F(i+1,j,2);
                suma3=suma3+D(dx+1,dy,3)-F(i+1,j,3);

            else
                S(blancos,A(i+1,j))=-1/4;
            end
            
            R1(blancos,1)=suma1/4;
            R2(blancos,1)=suma2/4;
            R3(blancos,1)=suma3/4;
        
                        blancos=blancos+1;

        end
            
    end
end

%% Resolvemos el sistema con las funciones incorporadas en Matlab
tic
METODO = 2;
switch METODO
    case 1
        %Metodo del residuo casi minimo
        display 'Metodo residuo casi minimo'
        F1 = qmr(S,R1);
        F2 = qmr(S,R2);
        F3 = qmr(S,R3);
    case 2
        %Resolverlo por el gradiente conjugado
        display 'Metodo gradiente conjugado'
        F1 = bicg(S,R1,1.e-06,10000);
        F2 = bicg(S,R2,1.e-06,10000);
        F3 = bicg(S,R3,1.e-06,10000);
    case 3
        %Metodo de Gauss
        display 'Metodo de gauss'
        F1=S\R1;
        F2=S\R2;
        F3=S\R3;
end
toc

%% Creamos la matriz correcion
C=zeros(nfilas,ncolumnas,3);

m=1; %con m accederemos al vector de soluciones
C=double(C);
for i=1:nfilas
for j=1:ncolumnas
    if(M(i,j)==0)
        C(i,j,1)=D(destFila+i-1,destColumna+j-1,1)-F(i,j,1);
        C(i,j,2)=D(destFila+i-1,destColumna+j-1,2)-F(i,j,2);
        C(i,j,3)=D(destFila+i-1,destColumna+j-1,3)-F(i,j,3);
    end
    if(M(i,j)==255)
      
     C(i,j,1)=F1(m,1);   
     C(i,j,2)=F2(m,1);   
     C(i,j,3)=F3(m,1);   
     m=m+1;     
    end 
end
end

%% Creamos la imagen final

X=D;  %sera la imagen con la que trabajaremos
for i=1:nfilas
    for j=1:ncolumnas
        if(M(i,j)==255)
         X(destFila+i-1,destColumna+j-1,1)=F(i,j,1)+C(i,j,1);
         X(destFila+i-1,destColumna+j-1,2)=F(i,j,2)+C(i,j,2);
         X(destFila+i-1,destColumna+j-1,3)=F(i,j,3)+C(i,j,3);
        end  
    end
end

X=uint8(X);
C=uint8(C);

%% Volcacamos la matriz a un fichero fisico
imwrite(C,'correcion.bmp');
imwrite(X,'final.jpg');