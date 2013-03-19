use File::Basename;

@terminos;
%vocabulario;
$bandera_ni;
@palabras_archivo;

sub open_dir{
	my ($path) = ($_[0]);
	opendir(DIR, $path) or die $!; #se abre el directorio
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
	
	print "Vocabulario\n\n";
	print "Termino, Ni\n";
	while (($key, $value) = each(%vocabulario)){
     		
     		print $key.", ".$value."\n";
	}
}

sub abrir_archivo{
	my ($path) = ($_[0]);
	open (MYFILE, $path);
	@terminos;
	while (<MYFILE>) {
		chop();
		$linea = $_;	
		print $linea."\n";
		#$linea =~ tr/A-Z/a-z/;	
		#$linea =~ tr/·ÈÌÛ˙¸¡…Õ”⁄‹/aeiouuaeiouu/;
		$linea =~ s/-\n//g;	

		@palabras = split (' ', $linea);
		$largo = @palabras;

		for ($i = 0; $i < $largo; $i++) {
			#print $palabras[$i]."\n";
			$temporal = $palabras[$i];
			if (!($temporal =~ /^[0-9]+$/)){
				$temporal =~ s/,//g;
				push(@terminos, $temporal);
				$terminos{$temporal}++;			
			}
		}


	}
	close (MYFILE);
	
	
	
	#$largo = @terminos;
	#@sorted = sort {$b <=> $a} @terminos;
	#$primero = $sorted[0];
	#print "primero ".$primero."\n";
	
	#open (NUEVO, '>>/home/daniel/Escritorio/archivos/data.txt');
	#print NUEVO $path.";".fileparse($path).";".$largo.";".$terminos{$primero}.";";
	#	foreach $palabra (sort keys (%terminos)) {
	#	   print NUEVO "(".$palabra.",".$terminos{$palabra}.");";
	#	}
	#print NUEVO "\n";
	#close (NUEVO); 
}

sub vocabulario{
	
}

sub uniq {
    return keys %{{ map { $_ => 1 } @_ }};
}

&open_dir("/home/daniel/Escritorio/archivos");
