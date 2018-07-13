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
#print "\nIndexed sub-features? : ", $db->index_subfeatures, "\n";

#my $segment = $db->segment($ARGV[0], $ARGV[1], $ARGV[2]);
#my @genes = $segment->features('gene:MSU_osa1r7');

#print OUT "\nGenes at $ARGV[0]:$ARGV[1]..$ARGV[2] are: \n";
#foreach my $gene (@genes) {
#  print $gene, "\n";
#}

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
#  print OUT $feature->display_name, "\t", $feature->start(), "-", $feature->end(), "\t", $strand, "\t", $feature->get_tag_values('Note'), "\t";
print OUT ">".$feature->display_name;
 #foreach my $go (@go) {
  #  print OUT $go, ", ";
  #}
 # print OUT "\n";
  print OUT "\n";
  my $featSeq=$db->fetch_sequence($ARGV[0], $feature->start(), $feature->end());
 # print OUT "Non-rev: ", $featSeq, "\t";
 # if ($strand eq "-") {
 #   $featSeq=scalar reverse($featSeq);
 # }
  print OUT $featSeq, "\n";
}
close(OUT);

