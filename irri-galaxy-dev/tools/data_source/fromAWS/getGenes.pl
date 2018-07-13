#!/usr/bin/perl -w
# ref: http://doc.bioperl.org/releases/bioperl-1.4/Bio/SeqFeature/Generic.html#POD21
use strict;
use Bio::DB::SeqFeature::Store;
use Bio::SeqFeature::Generic;

my $adaptor  = 'DBI::mysql';
my $database = 'msu7';
my $host     = 'localhost';
my $user     = 'ubuntu';
my $password = 'ubuntu';
my $dsn      = "$database:$host";
my $outfile = $ARGV[3];

my $db = Bio::DB::SeqFeature::Store-> new ( -adaptor=> $adaptor,
                                            -dsn    => $dsn,
                                            -user   => $user,
                                            -pass   => $password,

                                          );
open(OUT,">$outfile") or die "Cannot open $outfile";

##MAU
print OUT "<HTML>\n";
print OUT "<HEAD>\n";
#print OUT "<TITLE>Get Genes in region </TITLE>\n";
print OUT "</HEAD>\n";
print OUT "<BODY>\n";
##MAU
#print OUT "<P>Genes at $ARGV[0]:$ARGV[1]..$ARGV[2] are: </P>\n";
print OUT "<P>GeneID\tF_start-F_end\tStrand\tNote\tGO_annotation</P>\n";

#print OUT "\nGenes at $ARGV[0]:$ARGV[1]..$ARGV[2] are: \n"; ## Mau


my @features = $db->features(-seqid    => $ARGV[0],
                             -types    => ['gene:MSU_osa1r7'],
                             -start    => $ARGV[1],
                             -end      => $ARGV[2]
                             );

foreach my $feature (@features) {
  my @go=$feature->get_tag_values('Ontology_term');
  my $strand="-";
  if ($feature->strand==1){
    $strand="+";

  }
  print OUT "<P>\n"; ## Mau
  print OUT "<A HREF=\"http://rice.plantbiology.msu.edu/cgi-bin/ORF_infopage.cgi?orf=".$feature->display_name."\""."target=\"_blank\">".$feature->display_name."</A>"."\t"; ## MAU
  print OUT $feature->start(), "-", $feature->end(), "\t", $strand, "\t", $feature->get_tag_values('Note'), "\t";  #MAU

  #print OUT $feature->display_name, "\t", $feature->start(), "-", $feature->end(), "\t", $strand, "\t", $feature->get_tag_values('Note'), "\t"; #MAU - this is the no-web service version ...
  foreach my $go (@go) {
    #print OUT "<html><a>".$go."</a></html>".", "; ##MAU - this fails ...
    print OUT "<A HREF=\"http://www.ebi.ac.uk/QuickGO/GTerm?id=".$go."\""."target=\"_blank\">".$go."</A>"."\;"; ## MAU
  }
  
##MOD MAU
  print OUT "</P>\n"; #Mau
  #print OUT "\n";

#  print OUT "\t"; #Mau
#  my $featSeq=$db->fetch_sequence($ARGV[0], $feature->start(), $feature->end()); #Mau
#  print OUT "Non-rev: ", $featSeq, "\t"; #Mau
#  if ($strand eq "-") { #Mau
#    $featSeq=scalar reverse($featSeq); #Mau
#  } #Mau
#  print OUT "Sequence: ", $featSeq, "\n"; #Mau

} ## END foreach my $feature(@features)
print OUT "</P>\n"; #Mau
print OUT "</BODY>\n"; #Mau
print OUT "</HTML>\n"; #Mau



close(OUT);

