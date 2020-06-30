#!/usr/bin/perl
# project1.plx
use warnings;
use strict;
use Math::Trig;
use Data::Dumper;

my $rf1;
my $rf2;
my $rf3;
my $rf4;
my $rf5;
my $rf6;
my $rf7;
my $rf8;
my $rf9;
my $rf10;
my $rf11;
my $rf12;
my $rf13;
my $rf14;
my @eV;
my @Di;
my @nstate;
my $sigma;
my $nf;
my $outfile;
my $outrl="outrl.txt";
my $outmh="outmh.txt";
my $outml="outml.txt";
my $outbands="outbands.txt";
my $file;
my @eVrl;
my @eVmh;
my @eVml;
my @Dirl;
my @Dimh;
my @Diml;
my $num=0;
my %peakrl;
my %peakmh;
my %peakml;
my $xstart=0;
my @npeaksrl;
my @npeaksmh;
my @npeaksml;
my $count=0;
my @xpeak;
my @ypeak;
my $y;
my $yoniom=0;
my @hbw;
my $step;
my $x;
my $end;
my %expeaksrl;
my %expeaksmh;
my %expeaksml;
my $hfix;
my $mpeak;
my @array;
my $ratio;
my $change;
my $hnew;
my $hold;
my $horigin;
my $hsorigin;
my $hsnew;
my $hsold;
my $worigin;
my $wsorigin;
my $wnew;
my $wsnew;
my $changes;
my $extn;
my $sdtrl=0.2;
my $sdtmh=0.2;
my $sdtml=0.2;
my @sdtrlleft;
my @sdtrlright;
my @sdtmhleft;
my @sdtmhright;
my @sdtmlleft;
my @sdtmlright;
my $plotonly;

if ($#ARGV==1)
{
 unless($ARGV[1]=~/plotonly/) {$outfile=$ARGV[1];}
 $file=$ARGV[0];
 ($rf1, $rf2, $rf3,$rf4,$rf5,$rf6,$rf7,$rf8,$rf9,$rf10,$rf11,$rf12,$rf13,$rf14) = OneFileRead($file);
 @eV=@$rf1;
 @Di=@$rf2;
 @nstate=@$rf3;
 $extn=$$rf4-1;
 $sigma=$$rf5;
 $sdtrl=$$rf6;
 $sdtmh=$$rf7;
 $sdtml=$$rf8;
 @sdtrlleft=@$rf9;
 @sdtrlright=@$rf10;
 @sdtmhleft=@$rf11;
 @sdtmhright=@$rf12;
 @sdtmlleft=@$rf13;
 @sdtmlright=@$rf14;

 if($file=~/txt/)
 {
  while($count<$#eV)
  {
   if($eV[$count+0]!~/ /)
   {
    push (@eVrl, $eV[$count+0]);
    push (@Dirl, $Di[$count+0]);
   }
   if($eV[$count+1]!~/ /)
   {
    push (@eVmh, $eV[$count+1]);
    push (@Dimh, $Di[$count+1]);
   }
   if($eV[$count+2]!~/ /)
   {
    push (@eVml, $eV[$count+2]);
    push (@Diml, $Di[$count+2]);
   }
   $count=$count+3;
  }
  $count=0;
 }
 else
 {
  $nstate[2]=$nstate[0];
  while($num <= $#eV)
  {
   if($num < $nstate[1])
   {
    push (@eVrl, $eV[$num]);
    push (@Dirl, $Di[$num]);
   }
   if($num < $nstate[0]+$nstate[1] && $num >= $nstate[1])
   {
    push (@eVmh, $eV[$num]);
    push (@Dimh, $Di[$num]);
   }
   if($num < $nstate[0]+$nstate[1]+$nstate[2] && $num >=$nstate[1]+$nstate[0])
   {
    push (@eVml, $eV[$num]);
    push (@Diml, $Di[$num]);
   }
   $num++;
  }
  $num=0;
 }
}
elsif ($#ARGV==3)
{
 unless($ARGV[3]=~/plotonly/) {$outfile=$ARGV[3];}
 $file=$ARGV[0];
 ($rf1, $rf2, $rf3,$rf4,$rf5,$rf6,$rf7,$rf8,$rf9,$rf10,$rf11,$rf12,$rf13,$rf14) = OneFileRead($file);
 @eVrl=@$rf1;
 @Dirl=@$rf2;
 $extn=$$rf4-1;
 $sigma=$$rf5;
 $sdtrl=$$rf6;
 $sdtmh=$$rf7;
 $sdtml=$$rf8;
 # @cutptrl=@$rf9;
 # @cutptmh=@$rf10;
 # @cutptml=@$rf11;
 # @sdtrlmulti=@$rf12;
 # @sdtmhmulti=@$rf13;
 # @sdtmlmulti=@$rf14;
 @sdtrlleft=@$rf9;
 @sdtrlright=@$rf10;
 @sdtmhleft=@$rf11;
 @sdtmhright=@$rf12;
 @sdtmlleft=@$rf13;
 @sdtmlright=@$rf14;

 $file=$ARGV[1];
 ($rf1, $rf2, $rf3,$rf4,$rf5,$rf6,$rf7,$rf8,$rf9,$rf10,$rf11,$rf12,$rf13,$rf14) = OneFileRead($file);
 @eVmh=@$rf1;
 @Dimh=@$rf2;

 $file=$ARGV[2];
 ($rf1, $rf2, $rf3,$rf4,$rf5,$rf6,$rf7,$rf8,$rf9,$rf10,$rf11,$rf12,$rf13,$rf14) = OneFileRead($file);
 @eVml=@$rf1;
 @Diml=@$rf2;
}
#print "$sdtrl\n";
#print "$sdtmh\n";
#print "$sdtml\n";
#print "@sdtrlleft\n";
#print "@sdtrlright\n";
#print "@sdtmhleft\n";
#print "@sdtmhright\n";
#print "@sdtmlleft\n";
#print "@sdtmlright\n";

%peakrl = PeakFinder(\@eVrl,\@Dirl,\$sigma,\$outrl);
%peakmh = PeakFinder(\@eVmh,\@Dimh,\$sigma,\$outmh);
%peakml = PeakFinder(\@eVml,\@Diml,\$sigma,\$outml);

%peakrl=BandWidthFinder(\%peakrl,\$outrl);
%peakmh=BandWidthFinder(\%peakmh,\$outmh);
%peakml=BandWidthFinder(\%peakml,\$outml);

if($ARGV[$#ARGV]=~/plotonly/)
{
 @npeaksrl = keys (%peakrl);
 @npeaksrl = sort {$a<=>$b} @npeaksrl;
 @npeaksmh = keys (%peakmh);
 @npeaksmh = sort {$a<=>$b} @npeaksmh;
 @npeaksml = keys (%peakml);
 @npeaksml = sort {$a<=>$b} @npeaksml;
 print "number of peaks on rl spectrum=",($#npeaksrl+1),"\n";
 print "number of peaks on mh spectrum=",($#npeaksmh+1),"\n";
 print "number of peaks on ml spectrum=",($#npeaksml+1),"\n";
 print Dumper(\%peakrl);
 print Dumper(\%peakmh);
 print Dumper(\%peakml);
 open (OUTBANDS, '>'.$outbands) or die ("error");
 print OUTBANDS "number of peaks on rl spectrum=",($#npeaksrl+1),"\n";
 print OUTBANDS "number of peaks on mh spectrum=",($#npeaksmh+1),"\n";
 print OUTBANDS "number of peaks on ml spectrum=",($#npeaksml+1),"\n";
 print OUTBANDS Dumper(\%peakrl);
 print OUTBANDS Dumper(\%peakmh);
 print OUTBANDS Dumper(\%peakml);
 close OUTBANDS;
 exit;
}

if(@sdtrlleft && $sdtrlleft[$#sdtrlleft]!~/#/){%peakrl=SmallShoulderrange(\%peakrl,\$outrl,\@sdtrlleft,\@sdtrlright,\$sdtrl);}
else
{
 if($sdtrl=~/^[0-9,.E]+$/) {%peakrl=SmallShoulder(\%peakrl,\$outrl,\$sdtrl);}
}
if(@sdtmhleft && $sdtmhleft[$#sdtmhleft]!~/#/){%peakmh=SmallShoulderrange(\%peakmh,\$outmh,\@sdtmhleft,\@sdtmhright,\$sdtmh);}
else
{
 if($sdtmh=~/^[0-9,.E]+$/) {%peakmh=SmallShoulder(\%peakmh,\$outmh,\$sdtmh);}
}
if(@sdtmlleft && $sdtmlleft[$#sdtmlleft]!~/#/){%peakml=SmallShoulderrange(\%peakml,\$outml,\@sdtmlleft,\@sdtmlright,\$sdtml);}
else
{
 if($sdtml=~/^[0-9,.E]+$/) {%peakml=SmallShoulder(\%peakml,\$outml,\$sdtml);}
}

@npeaksrl = keys (%peakrl);
@npeaksrl = sort {$a<=>$b} @npeaksrl;
@npeaksmh = keys (%peakmh);
@npeaksmh = sort {$a<=>$b} @npeaksmh;
@npeaksml = keys (%peakml);
@npeaksml = sort {$a<=>$b} @npeaksml;
if ($#npeaksrl<$extn || $#npeaksmh<$extn || $#npeaksml<$extn)
{
 print "Inconsistent numbers of bands found among subcalculations, extrapoltion cannot be done.";
 exit;
}
while($count<=$extn)
{
 if($peakrl{$npeaksrl[$count]}[3])
 {
  $mpeak=$peakrl{$npeaksrl[$count]}[3];
  $change=11;
  $changes=11;
  $horigin=$peakrl{$mpeak}[1];
  $hnew=$horigin;
  $worigin=$peakrl{$mpeak}[2];
  $wnew=$worigin;
  $hsorigin=$peakrl{$npeaksrl[$count]}[1];
  $hsnew=$hsorigin;
  $wsorigin=$peakrl{$npeaksrl[$count]}[2];
  $wsnew=$wsorigin;
  while($change>10 && $changes>10)
  {
   $hfix=$hsnew*exp(-(($peakrl{$mpeak}[0]-$peakrl{$npeaksrl[$count]}[0])/$wsnew)**2);
   $hold=$hnew;
   $hnew=$horigin-$hfix;
   $ratio=$hnew/$horigin;
   $wnew=$worigin*sqrt(-log($ratio*exp(-1)));
   $change=abs($hold-$hnew);
   $hfix=$hnew*exp(-(($peakrl{$npeaksrl[$count]}[0]-$peakrl{$mpeak}[0])/$wnew)**2);
   $hsold=$hsnew;
   $hsnew=$hsorigin-$hfix;
   $changes=abs($hsnew-$hsold);
   $ratio=$hsnew/$hsorigin;
   $wsnew=$wsorigin*sqrt(-log($ratio*exp(-1)));
  }
  $peakrl{$npeaksrl[$count]}[1]=$hsnew;
  $peakrl{$mpeak}[1]=$hnew;
  $peakrl{$npeaksrl[$count]}[2]=$wsnew;
  $peakrl{$mpeak}[2]=$wnew;
 }

 if($peakmh{$npeaksmh[$count]}[3])
 {
  $mpeak=$peakmh{$npeaksmh[$count]}[3];
  $change=11;
  $changes=11;
  $horigin=$peakmh{$mpeak}[1];
  $hnew=$horigin;
  $worigin=$peakmh{$mpeak}[2];
  $wnew=$worigin;
  $hsorigin=$peakmh{$npeaksmh[$count]}[1];
  $hsnew=$hsorigin;
  $wsorigin=$peakmh{$npeaksmh[$count]}[2];
  $wsnew=$wsorigin;
  while($change>10 && $changes>10)
  {
   $hfix=$hsnew*exp(-(($peakmh{$mpeak}[0]-$peakmh{$npeaksmh[$count]}[0])/$wsnew)**2);
   $hold=$hnew;
   $hnew=$horigin-$hfix;
   $ratio=$hnew/$horigin;
   $wnew=$worigin*sqrt(-log($ratio*exp(-1)));
   $change=abs($hold-$hnew);
   $hfix=$hnew*exp(-(($peakmh{$npeaksmh[$count]}[0]-$peakmh{$mpeak}[0])/$wnew)**2);
   $hsold=$hsnew;
   $hsnew=$hsorigin-$hfix;
   $changes=abs($hsnew-$hsold);
   $ratio=$hsnew/$hsorigin;
   $wsnew=$wsorigin*sqrt(-log($ratio*exp(-1)));
  }
  $peakmh{$npeaksmh[$count]}[1]=$hsnew;
  $peakmh{$mpeak}[1]=$hnew;
  $peakmh{$npeaksmh[$count]}[2]=$wsnew;
  $peakmh{$mpeak}[2]=$wnew;
 }
 
 if($peakml{$npeaksml[$count]}[3])
 {
  $mpeak=$peakml{$npeaksml[$count]}[3];
  $change=11;
  $changes=11;
  $horigin=$peakml{$mpeak}[1];
  $hnew=$horigin;
  $worigin=$peakml{$mpeak}[2];
  $wnew=$worigin;
  $hsorigin=$peakml{$npeaksml[$count]}[1];
  $hsnew=$hsorigin;
  $wsorigin=$peakml{$npeaksml[$count]}[2];
  $wsnew=$wsorigin;
  while($change>10 && $changes>10)
  {
   $hfix=$hsnew*exp(-(($peakml{$mpeak}[0]-$peakml{$npeaksml[$count]}[0])/$wsnew)**2);
   $hold=$hnew;
   $hnew=$horigin-$hfix;
   $ratio=$hnew/$horigin;
   $wnew=$worigin*sqrt(-log($ratio*exp(-1)));
   $change=abs($hold-$hnew);
   $hfix=$hnew*exp(-(($peakml{$npeaksml[$count]}[0]-$peakml{$mpeak}[0])/$wnew)**2);
   $hsold=$hsnew;
   $hsnew=$hsorigin-$hfix;
   $changes=abs($hsnew-$hsold);
   $ratio=$hsnew/$hsorigin;
   $wsnew=$wsorigin*sqrt(-log($ratio*exp(-1)));
  }
  $peakml{$npeaksml[$count]}[1]=$hsnew;
  $peakml{$mpeak}[1]=$hnew;
  $peakml{$npeaksml[$count]}[2]=$wsnew;
  $peakml{$mpeak}[2]=$wnew;
 }
 $count++;
}
$count=0;

print Dumper(\%peakrl);
print Dumper(\%peakmh);
print Dumper(\%peakml);
open (OUTBANDS, '>'.$outbands) or die ("error");
print OUTBANDS Dumper(\%peakrl);
print OUTBANDS Dumper(\%peakmh);
print OUTBANDS Dumper(\%peakml);
close OUTBANDS;

#while($count<=$extn)   for regular peak extrapolation
#{
# $xpeak[$count]=$peakrl{$npeaksrl[$count]}[0]+$peakmh{$npeaksmh[$count]}[0]-$peakml{$npeaksml[$count]}[0];
# $ypeak[$count]=$peakrl{$npeaksrl[$count]}[1]+$peakmh{$npeaksmh[$count]}[1]-$peakml{$npeaksml[$count]}[1];
# $hbw[$count]=$peakrl{$npeaksrl[$count]}[2]+$peakmh{$npeaksmh[$count]}[2]-$peakml{$npeaksml[$count]}[2];
# $count++;
#}
while($count<=$extn)  #for skiping a specific band in extrapolation
{
 $xpeak[$count]=$peakrl{$npeaksrl[$count]}[0]+$peakmh{$npeaksmh[$count]}[0]-$peakml{$npeaksml[$count]}[0];
 $ypeak[$count]=$peakrl{$npeaksrl[$count]}[1]+$peakmh{$npeaksmh[$count]}[1]-$peakml{$npeaksml[$count]}[1];
 $hbw[$count]=$peakrl{$npeaksrl[$count]}[2]+$peakmh{$npeaksmh[$count]}[2]-$peakml{$npeaksml[$count]}[2];
 if($count>=1)
 {
  $xpeak[$count]=$peakrl{$npeaksrl[$count]}[0]+$peakmh{$npeaksmh[$count+1]}[0]-$peakml{$npeaksml[$count]}[0];
  $ypeak[$count]=$peakrl{$npeaksrl[$count]}[1]+$peakmh{$npeaksmh[$count+1]}[1]-$peakml{$npeaksml[$count]}[1];
  $hbw[$count]=$peakrl{$npeaksrl[$count]}[2]+$peakmh{$npeaksmh[$count+1]}[2]-$peakml{$npeaksml[$count]}[2];
 }
 $count++;
}
#first while has to be off if second while is on
#adjust n in $npeaks...[$count+n] to decide which band to skip
#count start at 0
#this currently is skipping the second band in mh spectrum

$count=0;
if ($xpeak[0]-5<0) {$xstart=0;}
else {$xstart=$xpeak[0]-5;}
$end=$xpeak[$#xpeak]+5;
$step=($end-$xstart)/2000;
$x=$xstart;
open (OUTFILE, '>'.$outfile) or die ("error");
while ($x <= $end)
{
 while($count<=$#xpeak)
 {
  $y=$ypeak[$count]*exp(-(($x-$xpeak[$count])/$hbw[$count])**2);
  $yoniom=$yoniom+$y;
  $count++;
 }
 $count=0;
 $x = sprintf("%.5f", $x);
 $yoniom = sprintf("%.5f", $yoniom);
 print OUTFILE "$x   $yoniom\n"; 
 $x = $x+$step;
 $yoniom=0;
}
close OUTFILE;

#*************************************subroutine*************OneFileRead****************************subroutine*****************************************
#This subroutine extract data from gaussian output file
sub OneFileRead 
{
 my $file;
 my @array;
 my $count=0;
 my $num=0;
 my @nstateline;
 my @nstatel;
 my @Nstate;
 my @nstate;
 my $nstatel;
 my @line;
 my @eV;
 my @f;
 my @fi;
 my @Di;
 my $Di;
 my @lines;
 my @sep;
 my $extn=3;
 my $sigma=0.4;
 my $sdtrl=0.1;
 my $sdtmh=0.1;
 my $sdtml=0.1;
 my @sdtrlleft;
 my @sdtrlright;
 my @sdtmhleft;
 my @sdtmhright;
 my @sdtmlleft;
 my @sdtmlright;

$file=$_[0];
if($file=~/txt/)
{ 
 open (FILE, $file) or die ("error");
 @lines = <FILE>;
 close FILE;
 foreach (@lines)
 {
  @sep = split(/,/, $_);
  if($#sep==5)
  {
   chomp ($sep[0]);
   push (@eV, $sep[0]);
   chomp ($sep[1]);
   push (@fi, $sep[1]);
   chomp ($sep[2]);
   push (@eV, $sep[2]);
   chomp ($sep[3]);
   push (@fi, $sep[3]);
   chomp ($sep[4]);
   push (@eV, $sep[4]);
   chomp ($sep[5]);
   push (@fi, $sep[5]);
  }
  elsif($#sep==1)
  {
   chomp ($sep[0]);
   if($sep[0]=~/extn/){chomp($sep[1]); $extn=$sep[1];}
   elsif($sep[0]=~/sigma/){chomp($sep[1]); $sigma=$sep[1];}
   elsif($sep[0]=~/sdtrl/){chomp($sep[1]); $sdtrl=$sep[1];}
   elsif($sep[0]=~/sdtmh/){chomp($sep[1]); $sdtmh=$sep[1];}
   elsif($sep[0]=~/sdtml/){chomp($sep[1]); $sdtml=$sep[1];}
  }	   
 }
}
else
{
 open (FILE, $file) or die ("error");
 @array = <FILE>;
 close (FILE);
 while ($count <= $#array)
 {
	 #  if ($array[$count]=~/extn/ || $array[$count]=~/sdrl/ || $array[$count]=~/sdmh/ || $array[$count]=~/sdml/ || $array[$count]=~/sigma/ || $array[$count]=~/sdt/)
  if ($array[$count]=~/extn/ || $array[$count]=~/sd/ || $array[$count]=~/sigma/)
  {
   @sep=split(/,/, $array[$count]);
   chomp ($sep[0]);
   if($sep[0]=~/extn/){chomp($sep[1]); $extn=$sep[1];}
   if($sep[0]=~/sigma/){chomp($sep[1]); $sigma=$sep[1];}
   if($sep[0]=~/sdtrl/ && $sep[0]!~/sdtrlleft/ && $sep[0]!~/sdtrlright/){chomp($sep[1]); $sdtrl=$sep[1];}
   if($sep[0]=~/sdtmh/ && $sep[0]!~/sdtmhleft/ && $sep[0]!~/sdtmhright/){chomp($sep[1]); $sdtmh=$sep[1];}
   if($sep[0]=~/sdtml/ && $sep[0]!~/sdtmlleft/ && $sep[0]!~/sdtmlright/){chomp($sep[1]); $sdtml=$sep[1];}
   #   if($sep[0]=~/cutptrl/)
   #   {
   #    while($num<$#sep)   
   #    {
   #     chomp($sep[$num+1]);
   #     push(@cutptrl,$sep[$num+1]);
   #     $num++;
   #    }
   #    $num=0;
   #   }
   #   if($sep[0]=~/cutptmh/)
   #   {
   #    while($num<$#sep)   
   #    {
   #     chomp($sep[$num+1]);
   #     push(@cutptmh,$sep[$num+1]);
   #     $num++;
   #    }
   #    $num=0;
   #   }
   #   if($sep[0]=~/cutptml/)
   #   {
   #    while($num<$#sep)   
   #    {
   #     chomp($sep[$num+1]);
   #     push(@cutptml,$sep[$num+1]);
   #     $num++;
   #    }
   #    $num=0;
   #   }
   if($sep[0]=~/sdtrlleft/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtrlleft,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
   if($sep[0]=~/sdtrlright/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtrlright,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
   if($sep[0]=~/sdtmhleft/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtmhleft,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
   if($sep[0]=~/sdtmhright/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtmhright,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
   if($sep[0]=~/sdtmlleft/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtmlleft,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
   if($sep[0]=~/sdtmlright/)
   {
    while($num<$#sep)   
    {
     chomp($sep[$num+1]);
     push(@sdtmlright,$sep[$num+1]);
     $num++;
    }
    $num=0;
   }
  }  
  elsif ($array[$count] =~ /#p/ && $count < 150)
  {
   @nstateline = split (/ /, $array[$count]);
   @nstateline = grep ($_, @nstateline);
   while ($num <= $#nstateline)
   {
    if ($nstateline[$num] =~ /td/)
    {
     @nstatel = split (/:/, $nstateline[$num]);
     foreach (@nstatel)
     {
      @Nstate = split (/=/, $_);
      push (@nstate, $Nstate[$#Nstate]);
     }
    }
    $num++;
   }
   $num=0;
  }
  elsif ($array[$count] =~ /Excited State /)
  {
   @line = split (/ /, $array[$count]);
   @line = grep($_, @line);
   while ($num <= $#line)
   {
    if ($line[$num] =~ /eV/)
    {
     push (@eV, $line[$num-1]);
    }
    if ($line[$num] =~ /f=/)
    {
     @f = split (/=/, $line[$num]);
     push (@fi, $f[$#f]);
    }
    $num++;
   }
   $num = 0;
  }
  $count++;
 }
}
 while ($num <= $#fi)
 {
  if ($fi[$num]!~/ /) #&& #$eV[$num]!~/ /)
  {
   $Di = $fi[$num] / (4.7017556079*(10**29)*8065.5447636345*$eV[$num]);
   push (@Di, $Di);
  }
  else {push (@Di, " ");} 
   $num++;
 }
 $num = 0;
 return (\@eV, \@Di, \@nstate, \$extn, \$sigma, \$sdtrl, \$sdtmh, \$sdtml,\@sdtrlleft,\@sdtrlright,\@sdtmhleft,\@sdtmhright,\@sdtmlleft,\@sdtmlright);
}

#*************************************subroutine****************PeakFinder*************************subroutine*****************************************
#This subroutine generate spectra and find peaks
sub PeakFinder
{
 my @Di;
 my @eV;
 my $x1;
 my $x2;
 my $step;
 my $end;
 my $ysum1=0;
 my $y;
 my $ysum2=0;
 my $sigma;
 my $output;
 my @peak;
 my %peaks;
 my ($ref1,$ref2,$ref3,$ref4)=@_;
 my $temp;
 my $npeak=0;
 my $xstart;
 
 @eV=@$ref1;
 @Di=@$ref2;
 $sigma=$$ref3;
 $output=$$ref4;
 $step=15/2000;

 if ($eV[0]-3 < 0) {$xstart=0;}
 else {$xstart=$eV[0]-3;}
 $end=$xstart+15;
 $x2=$xstart;
 while($num <= $#eV)
 {
  $y = $Di[$num]*$eV[$num]*exp(-(($x2-$eV[$num])/$sigma)**2)/(4*2.296*(10**(-39))*(pi**(1/2))*$sigma);
  $ysum2 = $ysum2 + $y;
  $num++;
 }
 $num=0;
 open (OUTFILE, '>'.$output) or die ("error");
 while ($x2<=$end)
 {
  while ($ysum2 <= $ysum1 && $x2<=$end)
  {
   $x1=$x2;
   $x2=$x2+$step;
   $ysum1=$ysum2;
   $ysum2=0;
   while($num <= $#eV)
   {
    $y = $Di[$num]*$eV[$num]*exp(-(($x2-$eV[$num])/$sigma)**2)/(4*2.296*(10**(-39))*(pi**(1/2))*$sigma);
    $ysum2 = $ysum2 + $y;
    $num++;
   }
   $x1 = sprintf("%.10f", $x1);
   $ysum1 = sprintf("%.10f", $ysum1);
   print OUTFILE "$x1 $ysum1\n";
   if ($x2>$end && $x1>0)
   {print OUTFILE "$x2 0\n";}
   $num=0;
  } 
  while ($ysum2 > $ysum1 && $x2<=$end)
  {
   $x1=$x2;
   $x2=$x2+$step;
   $ysum1=$ysum2;
   $ysum2=0;
   while($num <= $#eV)          
   {
    $y = $Di[$num]*$eV[$num]*exp(-(($x2-$eV[$num])/$sigma)**2)/(4*2.296*(10**(-39))*(pi**(1/2))*$sigma);
    $ysum2 = $ysum2 + $y;
    $num++;
   }
   $x1 = sprintf("%.10f", $x1);
   $ysum1 = sprintf("%.10f", $ysum1);
   print OUTFILE "$x1 $ysum1\n"; 
   $num=0;
   if ($ysum2<$ysum1 && $ysum1>100) 
   {
    $npeak=($x1-$xstart)/$step;
    $peaks{$npeak}[0]=$x1;
    $peaks{$npeak}[1]=$ysum1;
   }
  }
 }
 close OUTFILE;
 return (%peaks);
}

#*************************************subroutine****************BandWidthFinder*************************subroutine*****************************************
#This subroutine find out bandwidth
sub BandWidthFinder
{
 
 my $file;
 my %peaks;
 my ($ref1,$ref2)=@_;
 my @lines;
 my $line;
 my @sep;
 my @x;
 my @y;
 my $n=0;
 my $flag=0;
 my @npeaks;
 my $count=0;
 my $npeak;
 my $wright;
 my $wleft;
 my @hbws;
 my $epsheight;
 

 %peaks = %$ref1;
 $file = $$ref2;

 open (FILE, $file) or die ("error"); 
 @lines = <FILE>;
 close FILE;
 foreach (@lines)
 {
  @sep = split(/ /, $_);
  push (@x, $sep[0]);
  chomp ($sep[1]);
  push (@y, $sep[1]);
 }
 @npeaks = keys(%peaks);
 @npeaks = sort {$a<=>$b} @npeaks;
 while ($count<=$#npeaks)
 {
  $npeak=$npeaks[$count];
  $epsheight=$peaks{$npeak}[1]/exp(1);
  while ($flag==0)
  {
   if ($y[$npeak-$n-1] <= $y[$npeak-$n])
   {
    if (($y[$npeak-$n-1]-$epsheight)**2 >= ($y[$npeak-$n]-$epsheight)**2)
    {
     $wleft=$x[$npeak]-$x[$npeak-$n];
     $flag=1;
    }
    else {$n++;}
   }
   else {$wleft=0; $flag=1;} 
  }
  $n=0;
  $flag=0;
  while ($flag==0)
  {
   if ($y[$npeak+$n+1] <= $y[$npeak+$n])
   {
    if (($y[$npeak+$n+1]-$epsheight)**2 > ($y[$npeak+$n]-$epsheight)**2)
    {
     $wright=$x[$npeak+$n]-$x[$npeak];
     $flag=1;
    }
    else {$n++;}
   }
   else {$wright=0; $flag=1;}
  }
  $n=0;
  $flag=0;
  if ($wleft==0 && $wright==0) 
  {
   $epsheight=2*$peaks{$npeak}[1]/exp(1);
   while ($flag==0)
   {
    if ($y[$npeak-$n-1] <= $y[$npeak-$n])
    {
     if (($y[$npeak-$n-1]-$epsheight)**2 >= ($y[$npeak-$n]-$epsheight)**2)
     {
      $wleft=($x[$npeak]-$x[$npeak-$n])/sqrt(-log(2*exp(-1)));
      $flag=1;
     }
     else {$n++;}
    }
    else {$wleft=0; $flag=1;}
   }
  $n=0;
  $flag=0;
   while ($flag==0)
   {
    if ($y[$npeak+$n+1] <= $y[$npeak+$n])
    {
     if (($y[$npeak+$n+1]-$epsheight)**2 > ($y[$npeak+$n]-$epsheight)**2)
     {
      $wright=($x[$npeak+$n]-$x[$npeak])/sqrt(-log(2*exp(-1)));
      $flag=1;
     }
     else {$n++;}
    }
    else {$wright=0; $flag=1;}
   }
   $n=0;
   $flag=0;
   if ($wleft==0 && $wright==0) {$peaks{$npeak}[2]=0.4444;}
   elsif ($wright>=$wleft && $wleft!=0) {$peaks{$npeak}[2]=$wleft;}
   elsif ($wleft>=$wright && $wright!=0) {$peaks{$npeak}[2]=$wright;}
   elsif ($wleft==0) {$peaks{$npeak}[2]=$wright;}
   elsif ($wright==0) {$peaks{$npeak}[2]=$wleft;}
  }
  elsif ($wright>=$wleft && $wleft!=0) {$peaks{$npeak}[2]=$wleft;}
  elsif ($wleft>=$wright && $wright!=0) {$peaks{$npeak}[2]=$wright;}
  elsif ($wleft==0) {$peaks{$npeak}[2]=$wright;}
  elsif ($wright==0) {$peaks{$npeak}[2]=$wleft;} 
  $count++;
 }
 return (%peaks);
}

#subroutine****************SmallShoulder*************************subroutine*****************************************
#This subroutine find out shoulder under each peak
sub SmallShoulder
{
 my $file;
 my @lines;
 my @x;
 my @y;
 my @sep;
 my ($ref1,$ref2,$ref3)=@_;
 my @npeaks;
 my $count=0;
 my $npeak;
 my $sigma;
 my $n=0;
 my $num=0;
 my $flag=0;
 my %peaks;
 my $hbwreal;
 my $hbwgauss;
 my $nshoulder;
 my $epsheight;
 my $hbwepsgauss;
 my $hbwepsreal;
 my $find=0;
 my $ydiff;
 my $ydiffmax=0;
 my $sdt=0.2;
 my $nshoulderorig;

 %peaks = %$ref1;
 $file = $$ref2;
 $sdt=$$ref3;

 open (FILE, $file) or die ("error");
 @lines = <FILE>;
 close FILE;
 foreach (@lines)
 {
  @sep = split(/ /, $_);
  push (@x, $sep[0]);
  chomp ($sep[1]);
  push (@y, $sep[1]);
 }
 @npeaks = keys(%peaks);
 @npeaks = sort {$a<=>$b} @npeaks;
 while ($count<=$#npeaks)
 {
  $npeak=$npeaks[$count];
  $n=0;
  while ($y[$npeak-$n-1]<=$y[$npeak-$n] && $y[$npeak-$n]>0 && $find==0)
  {
   $hbwreal=$x[$npeak]-$x[$npeak-$n];
   $hbwgauss=sqrt(-log($y[$npeak-$n]/$y[$npeak]))*$peaks{$npeak}[2];
   if ($hbwreal-$hbwgauss>=$sdt)
   {
    $nshoulder=$npeak-$n;
    $nshoulderorig=$nshoulder;
    $find=1;
    while ($flag==0)
    {
     if ($y[$nshoulder-$num-1] < $y[$nshoulder-$num])
     {
      $ydiff=$y[$nshoulder-$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder-$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
      if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder-$num;}
      $num++;
     }
     else
     {
      if ($ydiff!=$ydiffmax)
      {
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
      }
      else
      {
       $nshoulder=$nshoulderorig;
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
      }
     }
    }
    $num=0;
    while ($flag==2)
    {
     if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
     {
      if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
      {
       $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
       $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss);
       if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
       $flag=1;
      }
      else {$num++;}
     }
     else
     {
      $epsheight=$epsheight*2;
      $num=0;
      while ($flag==2)
      {
       if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
       {
        if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
        {
         $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
         $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
         if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
         $flag=1;
        }
        else {$num++;}
       }
       else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
      }
     }
    }
   }
  $n++;
  }
  $n=0;
  $num=0;
  $flag=0;
  $find=0;
  while ($y[$npeak+$n+1]<=$y[$npeak+$n] && $y[$npeak+$n+1]>0 && $find==0)
  {
   $hbwreal=$x[$npeak+$n]-$x[$npeak];
   $hbwgauss=sqrt(-log($y[$npeak+$n]/$y[$npeak]))*$peaks{$npeak}[2];
   if ($hbwreal-$hbwgauss>=$sdt)
   {
    $nshoulder=$npeak+$n;
    $nshoulderorig=$nshoulder;
    $find=1;
    while ($flag==0)
    {
     if ($y[$nshoulder+$num+1] < $y[$nshoulder+$num])
     {
      $ydiff=$y[$nshoulder+$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder+$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
      if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder+$num;}
      $num++;
     }
     else
     {
      if ($ydiff!=$ydiffmax)
      {
      $peaks{$nshoulder}[0]=$x[$nshoulder];
      $peaks{$nshoulder}[1]=$y[$nshoulder];
      $peaks{$nshoulder}[3]=$npeak;
      $epsheight=$peaks{$nshoulder}[1]/exp(1);
      $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
      $flag=2;
      }
      else
      {
      $nshoulder=$nshoulderorig;
      $peaks{$nshoulder}[0]=$x[$nshoulder];
      $peaks{$nshoulder}[1]=$y[$nshoulder];
      $peaks{$nshoulder}[3]=$npeak;
      $epsheight=$peaks{$nshoulder}[1]/exp(1);
      $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
      $flag=2;
      }
     }
    }
    $num=0;
    while ($flag==2)
    {
     if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
     {
      if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
      {
       $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
       $peaks{$nshoulder}[2]=$hbwepsreal-$hbwepsgauss;
       if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
       $flag=1;
      }
      else {$num++;}
     }
     else
     {
      $epsheight=$epsheight*2;
      $num=0;
      while ($flag==2)
      {
       if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
       {
        if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
        {
         $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
         $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
         if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
         $flag=1;
        }
        else {$num++;}
       }
       else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
      }
     }
    }
   }
   $n++;
  }
  $count++;
  $n=0;
  $num=0;
  $flag=0;
  $find=0;
 }
 $count=0;
 return (%peaks);
}

#subroutine****************SmallShoulderrange*************************subroutine*****************************************
#This subroutine find out shoulder under each peak
sub SmallShoulderrange
{
 my $file;
 my @lines;
 my @x;
 my @y;
 my @sep;
 my ($ref1,$ref2,$ref3,$ref4,$ref5)=@_;
 my @npeaks;
 my $count=0;
 my $npeak;
 my $sigma;
 my $n=0;
 my $num=0;
 my $flag=0;
 my %peaks;
 my $hbwreal;
 my $hbwgauss;
 my $nshoulder;
 my $epsheight;
 my $hbwepsgauss;
 my $hbwepsreal;
 my $find=0;
 my $ydiff;
 my $ydiffmax=0;
 my $sdt=0.2;
 my $nshoulderorig;
 # my @cutpt;
 my @sdtleft;
 my @sdtright;

 %peaks = %$ref1;
 $file = $$ref2;
 @sdtleft=@$ref3;
 @sdtright=@$ref4;
 $sdt=$$ref5;


 open (FILE, $file) or die ("error");
 @lines = <FILE>;
 close FILE;
 foreach (@lines)
 {
  @sep = split(/ /, $_);
  push (@x, $sep[0]);
  chomp ($sep[1]);
  push (@y, $sep[1]);
 }
 @npeaks = keys(%peaks);
 @npeaks = sort {$a<=>$b} @npeaks;
 while ($count<=$#npeaks)
 {
  $npeak=$npeaks[$count];
  $n=0;
  if($sdtleft[$count] =~ /^[0-9,.E]+$/)
  {
   while ($y[$npeak-$n-1]<=$y[$npeak-$n] && $y[$npeak-$n]>0 && $find==0)
   {
    $hbwreal=$x[$npeak]-$x[$npeak-$n];
    $hbwgauss=sqrt(-log($y[$npeak-$n]/$y[$npeak]))*$peaks{$npeak}[2];
    if ($hbwreal-$hbwgauss>=$sdtleft[$count])
    {
     $nshoulder=$npeak-$n;
     $nshoulderorig=$nshoulder;
     $find=1;
     while ($flag==0)
     {
      if ($y[$nshoulder-$num-1] < $y[$nshoulder-$num])
      {
       $ydiff=$y[$nshoulder-$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder-$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
       if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder-$num;}
       $num++;
      }
      else
      {
       if ($ydiff!=$ydiffmax)
       {
        $peaks{$nshoulder}[0]=$x[$nshoulder];
        $peaks{$nshoulder}[1]=$y[$nshoulder];
        $peaks{$nshoulder}[3]=$npeak;
        $epsheight=$peaks{$nshoulder}[1]/exp(1);
        $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
        $flag=2;
       }
       else
       {
        $nshoulder=$nshoulderorig;
        $peaks{$nshoulder}[0]=$x[$nshoulder];
        $peaks{$nshoulder}[1]=$y[$nshoulder];
        $peaks{$nshoulder}[3]=$npeak;
        $epsheight=$peaks{$nshoulder}[1]/exp(1);
        $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
        $flag=2;
       }
      }
     }
     $num=0;
     while ($flag==2)
     {
      if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
      {
       if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
       {
        $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
        $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss);
        if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
        $flag=1;
       }
       else {$num++;}
      }
      else
      {
       $epsheight=$epsheight*2;
       $num=0;
       while ($flag==2)
       {
        if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
        {
         if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
         {
          $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
          $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
          if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
          $flag=1;
         }
         else {$num++;}
        }
        else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
       }
      }
     }
    }
   $n++;
   }
   $n=0;
   $num=0;
   $flag=0;
   $find=0;
  }
  elsif($sdtleft[$count] =~ /df/)
  {
   print "using df\n";
   $sdtleft[$count]=$sdt;
   while ($y[$npeak-$n-1]<=$y[$npeak-$n] && $y[$npeak-$n]>0 && $find==0)
   {
    $hbwreal=$x[$npeak]-$x[$npeak-$n];
    $hbwgauss=sqrt(-log($y[$npeak-$n]/$y[$npeak]))*$peaks{$npeak}[2];
    if ($hbwreal-$hbwgauss>=$sdtleft[$count])
    {
     $nshoulder=$npeak-$n;
     $nshoulderorig=$nshoulder;
     $find=1;
     while ($flag==0)
     {
      if ($y[$nshoulder-$num-1] < $y[$nshoulder-$num])
      {
       $ydiff=$y[$nshoulder-$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder-$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
       if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder-$num;}
       $num++;
      }
      else
      {
       if ($ydiff!=$ydiffmax)
       {
        $peaks{$nshoulder}[0]=$x[$nshoulder];
        $peaks{$nshoulder}[1]=$y[$nshoulder];
        $peaks{$nshoulder}[3]=$npeak;
        $epsheight=$peaks{$nshoulder}[1]/exp(1);
        $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
        $flag=2;
       }
       else
       {
        $nshoulder=$nshoulderorig;
        $peaks{$nshoulder}[0]=$x[$nshoulder];
        $peaks{$nshoulder}[1]=$y[$nshoulder];
        $peaks{$nshoulder}[3]=$npeak;
        $epsheight=$peaks{$nshoulder}[1]/exp(1);
        $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
        $flag=2;
       }
      }
     }
     $num=0;
     while ($flag==2)
     {
      if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
      {
       if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
       {
        $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
        $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss);
        if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
        $flag=1;
       }
       else {$num++;}
      }
      else
      {
       $epsheight=$epsheight*2;
       $num=0;
       while ($flag==2)
       {
        if ($y[$nshoulder-$num-1] <= $y[$nshoulder-$num])
        {
         if (($y[$nshoulder-$num-1]-$epsheight)**2 >= ($y[$nshoulder-$num]-$epsheight)**2)
         {
          $hbwepsreal=$x[$npeak]-$x[$nshoulder-$num];
          $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
          if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
          $flag=1;
         }
         else {$num++;}
        }
        else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
       }
      }
     }
    }
   $n++;
   }
   $n=0;
   $num=0;
   $flag=0;
   $find=0;
  }
  if($sdtright[$count] =~ /^[0-9,.E]+$/)
  {
   while ($y[$npeak+$n+1]<=$y[$npeak+$n] && $y[$npeak+$n+1]>0 && $find==0)
   {
    $hbwreal=$x[$npeak+$n]-$x[$npeak];
    $hbwgauss=sqrt(-log($y[$npeak+$n]/$y[$npeak]))*$peaks{$npeak}[2];
    if ($hbwreal-$hbwgauss>=$sdtright[$count])
    {
     $nshoulder=$npeak+$n;
     $nshoulderorig=$nshoulder;
     $find=1;
     while ($flag==0)
     {
      if ($y[$nshoulder+$num+1] < $y[$nshoulder+$num])
      {
       $ydiff=$y[$nshoulder+$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder+$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
       if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder+$num;}
       $num++;
      }
      else
      {
       if ($ydiff!=$ydiffmax)
       {
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
       }
       else
       {
       $nshoulder=$nshoulderorig;
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
       }
      }
     }
     $num=0;
     while ($flag==2)
     {
      if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
      {
       if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
       {
        $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
        $peaks{$nshoulder}[2]=$hbwepsreal-$hbwepsgauss;
        if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
        $flag=1;
       }
       else {$num++;}
      }
      else
      {
       $epsheight=$epsheight*2;
       $num=0;
       while ($flag==2)
       {
        if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
        {
         if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
         {
          $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
          $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
          if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
          $flag=1;
         }
         else {$num++;}
        }
        else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
       }
      }
     }
    }
    $n++;
   }
   $n=0;
   $num=0;
   $flag=0;
   $find=0;
  }
  elsif($sdtright[$count] =~ /df/)
  {
   $sdtright[$count]=$sdt;
   while ($y[$npeak+$n+1]<=$y[$npeak+$n] && $y[$npeak+$n+1]>0 && $find==0)
   {
    $hbwreal=$x[$npeak+$n]-$x[$npeak];
    $hbwgauss=sqrt(-log($y[$npeak+$n]/$y[$npeak]))*$peaks{$npeak}[2];
    if ($hbwreal-$hbwgauss>=$sdtright[$count])
    {
     $nshoulder=$npeak+$n;
     $nshoulderorig=$nshoulder;
     $find=1;
     while ($flag==0)
     {
      if ($y[$nshoulder+$num+1] < $y[$nshoulder+$num])
      {
       $ydiff=$y[$nshoulder+$num]-$peaks{$npeak}[1]*exp(-(($x[$nshoulder+$num]-$peaks{$npeak}[0])/$peaks{$npeak}[2])**2);
       if ($ydiff > $ydiffmax) {$ydiffmax=$ydiff; $nshoulder=$nshoulder+$num;}
       $num++;
      }
      else
      {
       if ($ydiff!=$ydiffmax)
       {
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
       }
       else
       {
       $nshoulder=$nshoulderorig;
       $peaks{$nshoulder}[0]=$x[$nshoulder];
       $peaks{$nshoulder}[1]=$y[$nshoulder];
       $peaks{$nshoulder}[3]=$npeak;
       $epsheight=$peaks{$nshoulder}[1]/exp(1);
       $hbwepsgauss=sqrt(-log($epsheight/$peaks{$nshoulder}[1]))*$peaks{$npeak}[2];
       $flag=2;
       }
      }
     }
     $num=0;
     while ($flag==2)
     {
      if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
      {
       if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
       {
        $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
        $peaks{$nshoulder}[2]=$hbwepsreal-$hbwepsgauss;
        if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=0.4;}
        $flag=1;
       }
       else {$num++;}
      }
      else
      {
       $epsheight=$epsheight*2;
       $num=0;
       while ($flag==2)
       {
        if ($y[$nshoulder+$num+1] <= $y[$nshoulder+$num])
        {
         if (($y[$nshoulder+$num+1]-$epsheight)**2 >= ($y[$nshoulder+$num]-$epsheight)**2)
         {
          $hbwepsreal=$x[$nshoulder+$num]-$x[$npeak];
          $peaks{$nshoulder}[2]=($hbwepsreal-$hbwepsgauss)/sqrt(-log(2*exp(-1)));
          if ($peaks{$nshoulder}[2]<0.05) {$peaks{$nshoulder}[2]=$peaks{$npeak}[2];}
          $flag=1;
         }
         else {$num++;}
        }
        else {$peaks{$nshoulder}[2]=0.4; $flag=1;} #$peaks{$npeak}[2]; $flag=1;}
       }
      }
     }
    }
    $n++;
   }
   $n=0;
   $num=0;
   $flag=0;
   $find=0;
  }
  $count++;
 }
 $count=0;
 return (%peaks);
}






