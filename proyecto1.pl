use File::Basename;

@stopwords;

sub crear_stops{
	my ($path) = ($_[0]);
	open(MYFILE, $path);
	
	while (<MYFILE>){
		$linea = $_;
		chomp($linea);
		#print $linea."\n";
		push(@stopwords, $linea);
	}
	#&open_dir("C:/Users/SirIsaac/Desktop/man.es");
	&open_dir("D:/man.es");
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
		$linea =~ tr/·ÈÌÛ˙¸¡…Õ”⁄‹/aeiouuaeiouu/;
		$linea =~ s/[\.]/ /g;
		$linea =~ s/[\;]/ /g;
		$linea =~ s/[\,]/ /g;
		$linea =~ s/[\(]/ /g;
		$linea =~ s/[\)]/ /g;
		$linea =~ s/[\[]/ /g;
		$linea =~ s/[\]]/ /g;		
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
		$linea =~ s/[\?]/ /g;
		$linea =~ s/[\<]/ /g;
		$linea =~ s/[\>]/ /g;
		$linea =~ s/[\']/ /g;
		$linea =~ s/[\`]/ /g;
		$linea =~ s/[\|]/ /g;
		$linea =~ s/[\/]/ /g;
		$linea =~ s/[\+]/ /g;
		
		$linea =~ s/-//g;
		
		@palabras = undef;
		$largo = 0;
		@palabras = split (' ', $linea);
		$largo = @palabras;
		
		if($bandera == 1){			
			$primera_palabra = $palabras[0];
			$palabra_final = $ultima_palabra.$primera_palabra;
			if(esta($palabra_final) == 1){
				$terminos{$palabra_final};
			}
			$bandera = 0;
			delete @palabras[0];
		}
				
		if($palabras[$largo-1] =~ m/[a-z0-9_]+≠$/){	
			$palabras[$largo-1] =~ s/≠//;
			$ultima_palabra = $palabras[$largo-1];		
			$bandera = 1;
			delete @palabras[$largo-1];	
		}
		
		for $word (@palabras){
			if (!($word =~ m/^[0-9]+/)){
				if(esta($word) == 1){
					push(@terminos, $word);
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
	%terminos = undef;
	
	close (NUEVO); 
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


#&crear_stops("C:/Users/SirIsaac/Desktop/stop.txt");
&open_dir("D:/stop.txt");