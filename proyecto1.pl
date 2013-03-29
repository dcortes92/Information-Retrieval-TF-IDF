# ISAAC! Para correr poner perl proyecto1.pl generar stop.txt D:\man.es .txt$ PRU
# la ruta no importa porque ahorita no funciona el tomar la ruta como parámetro, igual lo del patron .txt$
# Listo lo de pesos, si empieza con su parte de consultas, por fa seguir formato de abajo de declarar funciones
# Pongale atencion a la vara de "MAIN" que hay abajo Pura vida mae!!!


# I Tarea programada
# Recuperación de Información Textual
# Daniel Cortés Sáenz
# Isaac Ramírez Solano
# I Semestre, 2013

#Necesario para el manejo de archivos
use File::Basename;
#Necesario para raiz
use Math::Complex;

#Arreglo para los stopwords
@stopwords;
#Hash para los términos de un documento, usado para el archivo de frecuencias
%terminos;
#Hash para los pesos de un documento
%pesos;
#Numero de documentos
$N;
#Bandera para cuando se escribe el archivo de frecuencias o el de pesos
$bandera_accion;
#Hash para el vocabulario de la colección
%vocabulario = undef;
#Arreglo para el vocabulario de cada archivo.
@vocabulario_archivo;
#----------------------Variables de la línea de comandos-----------------------
#Generar
$comando;
$archivo_stopwords;
$directorio;
$patron;
$prefijo;
#Consulta
$modalidad;
$numinicio;
$numfin;
$prefijoconsulta;
$escalafon;
$archivoHTML;
$consulta;
#-------------------------Fin variables-------------------------

#Calcular frecuencias
sub calcular_frecuencias
{
	$bandera_accion = 1;
	&crear_stops;
	print "Creando archivo frecuencias...\n" ;
	&open_dir("D:/man.es");
	print "Creando archivo vocabulario...\n";	
	&escribir_archivo_vocabulario;
}

#Calcular pesos
sub calcular_pesos
{
	$bandera_accion = 0;
	print "Creando archivo pesos...\n" ;
	&open_dir("D:/man.es");
}

#Almacena en el arreglo @stopwords las palabras leídas del archivo de texto de stopwords.
sub crear_stops{
	#Ruta del archivo de texto de stopwords.
	#Se abre el archivo y se usa el file handler MYFILE
	open(MYFILE, $archivo_stopwords);
	#Mientras que MYFILE sea distinto de 0
	while (<MYFILE>){
		#Se lee la línea.
		$linea = $_;
		#Quita \n de línea.
		chomp($linea);
		#Se inserta la palabra en el arreglo.		
		push(@stopwords, $linea);
	}	
}

sub open_dir{
	my ($path) = ($_[0]);
	opendir(DIR, $path) or die("Error, No se pudo abrir el directorio\n");
	my @files = grep(!/^\./,readdir(DIR));
	closedir(DIR);
	foreach $file (@files){
		$file = $path.'/'.$file; #path absoluto del fichero o directorio
		next unless( -f $file or -d $file ); #se rechazan pipes, links, etc ..
	   	if( -d $file){
			open_dir($file,$hash);
		}else{
	   		if($file =~ /\.txt$/){
				#Se incrementa la variable N (Número de documentos)
				if($bandera_accion == 1){
					$N++;
				}				
	   			&abrir_archivo($file);
	   		}
		}		
	}
}

#Abrir cada archivo de la colección
sub abrir_archivo{
	my ($path) = ($_[0]);
	open (MYFILE, $path);
	#hash que tiene los términos de cada archivo
	%terminos =  undef;
	$ultima_palabra = undef;
	$bandera = 0;
	
	while (<MYFILE>) {
		$linea = $_;
		$linea =~ tr/A-Z/a-z/;	
		$linea =~ tr/áéíóúüÁÉÍÓÚÜ/aeiouuaeiouu/;
		$linea =~ s/[\.]/ /g;
		$linea =~ s/[\;]/ /g;
		$linea =~ s/[\,]/ /g;
		$linea =~ s/[\(]/ /g;
		$linea =~ s/[\)]/ /g;
		$linea =~ s/[\[]/ /g;
		$linea =~ s/[\]]/ /g;
		$linea =~ s/[\{]/ /g;
		$linea =~ s/[\}]/ /g;
		$linea =~ s/[\:]/ /g;
		$linea =~ s/[\¡]/ /g;
		$linea =~ s/[\!]/ /g;
		$linea =~ s/[\@]/ /g;
		$linea =~ s/[\#]/ /g;
		$linea =~ s/[\$]/ /g;
		$linea =~ s/[\%]/ /g;
		$linea =~ s/[\^]/ /g;
		$linea =~ s/[\&]/ /g;
		$linea =~ s/[\*]/ /g;
		$linea =~ s/[\=]/ /g;
		$linea =~ s/[\\]/ /g;
		$linea =~ s/[\"]/ /g;
		$linea =~ s/[\¿]/ /g;
		$linea =~ s/[\?]/ /g;
		$linea =~ s/[\<]/ /g;
		$linea =~ s/[\>]/ /g;
		$linea =~ s/[\']/ /g;
		$linea =~ s/[\`]/ /g;
		$linea =~ s/[\|]/ /g;
		$linea =~ s/[\/]/ /g;
		$linea =~ s/[\+]/ /g;
		$linea =~ s/[\~]/ /g;
		
		$linea =~ s/-//g;
		
		@palabras = undef;
		$largo = 0;
		@palabras = split (' ', $linea);
		$largo = @palabras;
		
		#Para unir las palabras con - al final (Isaac comentar mejor)
		if($bandera == 1){			
			$primera_palabra = $palabras[0];
			$palabra_final = $ultima_palabra.$primera_palabra;
			if(esta($palabra_final) == 1){
				$terminos{$palabra_final}++;
			}
			$bandera = 0;
			delete @palabras[0];
		}
				
		#Para unir las palabras con -a al final (Isaac comentar mejor)
		if($palabras[$largo-1] =~ m/[a-z0-9_]+­$/){	
			$palabras[$largo-1] =~ s/­//;
			$ultima_palabra = $palabras[$largo-1];		
			$bandera = 1;
			delete @palabras[$largo-1];	
		}
		
		for $word (@palabras){
			if (($word =~ m/[a-z0-9_]+/)&!($word =~ m/^[0-9]+/)){
				if(esta($word) == 1){
					$terminos{$word}++;
				}
			}
		}		
		$largo = 0;
		@palabras = undef;
	}
	close (MYFILE);
	
	$largo = scalar(keys %terminos)-1;
	@sorted = undef;
	@sorted = sort { $terminos{$a} < $terminos{$b} } keys %terminos;
	$primero = $sorted[0];
	@sorted = undef;
	
	#Frecuencias
	if($bandera_accion == 1)
	{
		open (NUEVO, '>>'.$prefijo.'_FC.txt');
		print NUEVO $path.";".fileparse($path).";".$largo.";".$terminos{$primero}.";";
			foreach $palabra (sort keys (%terminos)) {
				if($palabra cmp "")
				{
					print NUEVO "(".$palabra.",".$terminos{$palabra}.");";
				}
			}
		print NUEVO "\n";
		$largo = 0;
		close (NUEVO);
		
		#Se almacena el vocabulario de cada archivo para el hash de vocabulario de la colección
		foreach $word(sort keys (%terminos))
		{
			if($word cmp "")
			{	
				push(@vocabulario_archivo, $word);
			}		
		}	
		
		#Se actualiza el hash de vocabulario
		&actualizar_vocabulario;
	}
	else #Pesos
	{
		$norma = 0;
		foreach $pal(sort keys(%terminos))
		{
			if($pal cmp "")
			{
				$ni = $vocabulario{$pal};
				$fij = $terminos{$pal};
				if($fij > 0){
					$pesos{$pal} = ((log($fij)/log(2))+1)*(log($N/$ni)/log(2));
				}
				else
				{
					$pesos{$pal} = 0;
				}
				$norma += $pesos{$pal} ** 2;
			}			
		}
		$norma = sqrt($norma);
		open (NUEVO, '>>'.$prefijo.'_PE.txt');
		printf NUEVO $path.";".$largo.";"."%.4f;",$norma;
		foreach $palabra (sort keys (%pesos)) {
			if($palabra cmp "")
			{
				printf NUEVO "(".$palabra.",%.4f);", $pesos{$palabra};
			}
		}
		print NUEVO "\n";
		close (NUEVO);
		
	}	
	%pesos = undef;
	%terminos = undef;
	@vocabulario_archivo = undef; 
}

sub esta{
	my ($termino) = ($_[0]);
	for ($i = 0; $i < 37; $i++) {
		$elem = $stopwords[$i]."\n";
		$num = ($elem =~ /^$termino$/);
		if ($num == 1) {
			return 0;
		}
	}
	return 1;
}


#Para el par de (termino, ni) -> vocabulario de la colección
sub actualizar_vocabulario
{
	for $palabra(@vocabulario_archivo)
	{
		if($palabra cmp "")
		{
			$vocabulario{$palabra}++;
		}		
	}
}

#Escribe el archivo con el vocabulario de la colección y el ni
sub escribir_archivo_vocabulario
{
	if(%vocabulario)
	{
		open (NUEVO, '>'.$prefijo.'_VO.txt');
		foreach $pal(sort keys (%vocabulario)) {
			if($pal cmp "")
			{
				print NUEVO "(".$pal.",".$vocabulario{$pal}.")\n";
			}
		}
		close(NUEVO);
	}
	else
	{
		print "Error, vocabulario no tiene elementos\n";
	}
}

#--------------------------MAIN------------------------#
$comando = shift;
if($comando eq "generar")
{
	$archivo_stopwords = shift;
	$directorio = shift;
	$patron = shift;
	$prefijo = shift;
	
	if($archivo_stopwords eq "" or $directorio eq "" or $patron eq "" or $prefijo eq "")
	{
		print "Error, faltan parametros para generar\n";
	}
	else
	{
		&calcular_frecuencias;
		&calcular_pesos;
	}
}
elsif($comando eq "buscar")
{
	$modalidad = shift;
	$numinicio = shift;
	$numfin = shift;
	$prefijo = shift;
	$prefijoconsulta = shift;
	$escalafon = shift;
	$archivoHTML = shift;
	$consulta = shift;
	
	if($modalidad eq "" or $numinicio eq "" or $numfin eq "" or $prefijo eq "" or $prefijoconsulta eq "" or $escalafon eq "" or $archivoHTML eq "" or $consulta eq "")
	{
		print "Error, faltan parametros para buscar\n";
	}
	else
	{
		print "Buscar...\n";
	}
}
else
{
	print "Error, comando no reconocido\n";
}