#!/usr/bin/perl 

use strict;
use warnings;
use Data::Dumper;
use YAML;

BEGIN {
package CI::Site;
use Moose;

has Pages => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

sub snarf {
   my ($self, $url) = @_;
warn $url;
   my $p = CI::Page->new( url => $url )->snarf;
   $self->Pages->{$url} = $p;

   for my $link ( @{ $p->local_links } ) {
      if ( ! defined $self->Pages->{$link->{url}} ) {
         $self->snarf( $link->{url} );
      }
   }

   return $self;
}


package CI::Page;
use WWW::Mechanize;
use Moose;
use URI;

has url => ( is => 'rw', isa => 'Str', required => 1 );
has host => ( is => 'rw', isa => 'Str', lazy => 1, 
   default => sub { URI->new( shift->url)->host; }
);
has title => ( is => 'rw', isa => 'Str', default => sub{'undefind page name'} );
has local_links => ( is => 'rw', isa => 'ArrayRef', default => sub{ [] } );
has remote_links => ( is => 'rw', isa => 'ArrayRef', default => sub{ [] } );
has content => ( is => 'rw', isa => 'Str');
has images => ( is => 'rw', isa => 'Any', default => sub {[]} );

=pod
http://adaptivepath.com/ideas/essays/archives/000040.php

!!! NOTE:
- it would be nice to build out a semantic version of the page:
-- body:
--- H1: title
---- content
---- H2 : title
----- content
....

This would allow for the 'page' to be build towards the idea of 'perfection'
- then if anything is not 'perfect' then you know what you need to work on

Also try and carry the concept that this just builds the basic framework for some one to then go back thru and 'edit' to match what is really needed
=cut

sub snarf {
   my ($self) = @_;
   my $m   = WWW::Mechanize->new( );
   $m->get($self->url);

   if ( $m->success() ) {
      $self->title( $m->title );
      for my $link ( @{ $m->links } ) {
         if ( $self->_is_http($link) ) {
            if ($self->_is_local($link) ) {
               push @{ $self->local_links }, { text => $link->text, url => $link->URI->abs->as_string };
            }
            else {
               push @{ $self->remote_links }, { text => $link->text, url => $link->URI->abs->as_string };
            }
         } else {
            # not a real link ?
         }
      } 
      for my $img ( @{ $m->images } ) {
         push @{ $self->images }, { src => $img->url, url => $img->URI->abs->as_string, height => $img->height, width => $img->width, alt => $img->alt };
      }
   }
   else {
    # gracefully ignore errors
   }
   return $self;
}

sub _is_http {
   my ( $self, $link ) = @_;
   return $link->URI->rel->[0]->isa('URI::http');
}

sub _is_local {
   my ( $self, $link ) = @_;
   return ( $self->host eq $link->URI->abs->host);
}

} # END BEGIN






my $url = $ARGV[0] || 'http://develonizer.com/cgi-bin/site.cgi';
my $s   = CI::Site->new->snarf($url);

print Dump($s);
=pod
print Dumper( map{
               { $_->text => $_->url, path => [$_->url_abs->host] } 
              } $m->links() );
=cut



