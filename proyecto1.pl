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
<<<<<<< HEAD
	&open_dir("/home/daniel/man.es");
=======
	&open_dir("/home/isaac/man.es");
>>>>>>> e780bd56f42063e168fd803d054ab76f048f9272
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
<<<<<<< HEAD
		}
		else{
	   		if($file =~ /\.c$/){
=======
		}else{
	   		#print $file."\n";
<<<<<<< HEAD
	   		if($file =~ /\.c$/){
=======
	   		if($file =~ /\.txt$/){
>>>>>>> e780bd56f42063e168fd803d054ab76f048f9272
>>>>>>> 1792eacba2e1660ea46671bc4411875a51091258
	   			&abrir_archivo($file);	   				
	   		}
		}		
	}
}

sub abrir_archivo{
	my ($path) = ($_[0]);
	open (MYFILE, $path);
	%terminos = undef
	;
	$ultima_palabra;
	$bandera = 0;
	
	while (<MYFILE>) {
		$linea = $_;
		$linea =~ tr/A-Z/a-z/;	
		$linea =~ tr/������������/aeiouuaeiouu/;
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
		$linea =~ s/-/ /g;
		
		$largo = 0;
		@palabras = split (' ', $linea);
		$largo = @palabras;
			
		if($bandera == 1){			
			$primera_palabra = $palabras[0];
			$palabra_final = $ultima_palabra.$primera_palabra;
			if(esta($palabra_final) == 1){
				$terminos{$palabra_final}++;
			}
			$bandera = 0;
			delete @palabras[0];
		}
				
		if($palabras[$largo-1] =~ m/[a-z0-9_]+�$/){	
			$palabras[$largo-1] =~ s/�//;
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
	}
	close (MYFILE);
	
	$largo = (keys %terminos)-1;
	@sorted = sort { $terminos{$a} < $terminos{$b} } keys %terminos;
	$primero = $sorted[0];
<<<<<<< HEAD
	
	print "voy a crear archivo ".$largo."\n";
	open (NUEVO, ">>data.txt");
=======
<<<<<<< HEAD
	
	open (NUEVO, '>>/home/daniel/data.txt');
=======
	@sorted = undef;
	
	open (NUEVO, "/home/isaac>data.txt");
>>>>>>> e780bd56f42063e168fd803d054ab76f048f9272
>>>>>>> 1792eacba2e1660ea46671bc4411875a51091258
	print NUEVO $path.";".fileparse($path).";".$largo.";".$terminos{$primero}.";";
		foreach $palabra (sort keys (%terminos)) {
			if($palabra cmp "")
			{
				print NUEVO "(".$palabra.",".$terminos{$palabra}.");";
			}
		}
	print NUEVO "\n";
	close (NUEVO); 
	%terminos = undef;
}

sub esta{
	my ($termino) = ($_[0]);
	if($terminos cmp "")
	{
		return 0;
	}
	for ($i = 0; $i < 37; $i++) {
		$elem = $stopwords[$i]."\n";
		$num = ($elem =~ /\b$termino$/);
		if ($num == 1) {
			return 0;
		}
	}
	return 1;
}


<<<<<<< HEAD
crear_stops("/home/daniel/stop.txt");
=======
&crear_stops("/home/isaac/stop.txt");
>>>>>>> e780bd56f42063e168fd803d054ab76f048f9272
