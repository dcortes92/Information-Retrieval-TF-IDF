use File::Basename;

@stopwords;

sub crear_stops{
	my ($path) = ($_[0]);
	open(MYFILE, $path);
	
	while (<MYFILE>){
		$linea = $_;
		chomp($linea);
		push(@stopwords, $linea);
	}
	&open_dir("/home/man.es");
	#&esta("casa");
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
	@terminos;
	$ultima_palabra;
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

		@palabras = split (' ', $linea);
		$largo = @palabras;
				
		if($bandera == 1){
			$primera_palabra = $palabras[0];
			$palabra_final = $ultima_palabra.$primera_palabra;
			if(esta($palabra_final) == 1){
				push(@terminos, $palabra_final);
				$terminos{$palabra_final}++;
			}
			$bandera = 0;
		}
				
		if($palabras[$largo-1] =~ m/[a-z0-9_]+-$/){			
			$palabras[$largo-1] =~ s/-//;
			$ultima_palabra = $palabras[$largo-1];		
			$bandera = 1;	
		}
		
		$linea =~ s/\-//g;
		@palabras = split (' ', $linea);	
		
		if($bandera){
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


	}
	close (MYFILE);
	
	$largo = @terminos;
	@sorted = sort {$b < $a} @terminos;
	$primero = $sorted[0];
	$ruta = "/home/data.txt";
	
	open (NUEVO, '>>data.txt');
	print NUEVO $path.";".fileparse($path).";".$largo.";".$terminos{$primero}.";";
		foreach $palabra (sort keys (%terminos)) {
		   print NUEVO "(".$palabra.",".$terminos{$palabra}.");";
		}
	print NUEVO "\n";
	close (NUEVO); 
}

sub esta{
	my ($termino) = ($_[0]);
	#my $termino = "a";	
	for ($i = 0; $i < 37; $i++) {
		$x = $stopwords[$i]."\n";
		$num = ($x =~ /\b$termino\b/);
		if ($num == 1) {
			return 0;
		}
	}
	return 1;
}


crear_stops("/home/stop.txt");
