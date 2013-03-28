# I Tarea programada
# Recuperación de Información Textual
# Daniel Cortés Sáenz
# Isaac Ramírez Solano
# I Semestre, 2013

#Necesario para el manejo de archivos
use File::Basename;

#Arreglo para los stopwords
@stopwords;
#Hash para los términos de un documento, usado para el archivo de frecuencias
%terminos;
#Numero de documentos
$N;
#Bandera para saber cuando se termina de leer un archivo
$bandera_archivo;
#Hash para el vocabulario de la colección
%vocabulario;
#Arreglo para el vocabulario de cada archivo.
@vocabulario_archivo;

#Almacena en el arreglo @stopwords las palabras leídas del archivo de texto de stopwords.
sub crear_stops{
	#Ruta del archivo de texto de stopwords.
	my ($path) = ($_[0]);
	#Se abre el archivo y se usa el file handler MYFILE
	open(MYFILE, $path);
	#Mientras que MYFILE sea distinto de 0
	while (<MYFILE>){
		#Se lee la línea.
		$linea = $_;
		#Quita \n de línea.
		chomp($linea);
		#Se inserta la palabra en el arreglo.		
		push(@stopwords, $linea);
	}
	#&open_dir("C:/Users/SirIsaac/Desktop/man.es");	
	print "Creando archivo data...\n" ;
	&open_dir("D:/man.es");
	print "Creando archivo vocabulario...\n";	
	&escribir_archivo_vocabulario;
	print "N es ".$N."\n";
}

sub open_dir{
	my ($path) = ($_[0]);
	opendir(DIR, $path) or die $!;
	my @files = grep(!/^\./,readdir(DIR));
	closedir(DIR);
	foreach $file (@files){
		$file = $path.'/'.$file; #path absoluto del fichero o directorio
		next unless( -f $file or -d $file ); #se rechazan pipes, links, etc ..
	   	if( -d $file){
			open_dir($file,$hash);
		}else{
	   		#print $file."\n";
	   		if($file =~ /\.txt$/){
				$N++;
	   			&abrir_archivo($file);
	   		}
		}		
	}
}

sub abrir_archivo{
	my ($path) = ($_[0]);
	open (MYFILE, $path);
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
		
		#Para unir las palabras con - al final
		if($bandera == 1){			
			$primera_palabra = $palabras[0];
			$palabra_final = $ultima_palabra.$primera_palabra;
			if(esta($palabra_final) == 1){
				$terminos{$palabra_final};
			}
			$bandera = 0;
			delete @palabras[0];
		}
				
		if($palabras[$largo-1] =~ m/[a-z0-9_]+­$/){	
			$palabras[$largo-1] =~ s/­//;
			$ultima_palabra = $palabras[$largo-1];		
			$bandera = 1;
			delete @palabras[$largo-1];	
		}
		
		for $word (@palabras){
			if (!($word =~ m/^[0-9]+/)){
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
	
	open (NUEVO, '>>data.txt');
	print NUEVO $path.";".fileparse($path).";".$largo.";".$terminos{$primero}.";";
		foreach $palabra (sort keys (%terminos)) {
			if($palabra cmp "")
			{
				print NUEVO "(".$palabra.",".$terminos{$palabra}.");";
			}
		}
	print NUEVO "\n";
	$largo = 0;
	
	foreach $word(%terminos)
	{
		if(palabra_repetida($word) != 1)
		{
			push(@vocabulario_archivo, $word);
		}
	}	
	
	close (NUEVO);
	
	&actualizar_vocabulario;
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

sub palabra_repetida{
	my ($termino) = ($_[0]);
	for $palabra(@vocabulario_archivo) {		
		if($palabra eq $termino)
		{
			return 1;
		}		
	}
	return 0;
}

#Para el par de (termino, ni)
sub actualizar_vocabulario
{
	foreach $palabra(@vocabulario_archivo)
	{
		$vocabulario{$palabra}++;
	}
}

sub escribir_archivo_vocabulario
{
	open (NUEVO, '>>vocabulario.txt');
		foreach $pal(%vocabulario) {
			if($pal cmp "")
			{
				print NUEVO "(".$pal.",".$vocabulario{$pal}.");\n";
			}
		}
	close(NUEVO);
}


#&crear_stops("C:/Users/SirIsaac/Desktop/stop.txt");
&crear_stops("D:\stop.txt");