package WWW::Content::Inventory::Page;
use WWW::Mechanize;
use Moose;
use URI;

#---------------------------------------------------------------------------
#  what defines a page?
#---------------------------------------------------------------------------
has url => ( 
   is => 'rw', 
   isa => 'Str', 
   required => 1 
);

has host => ( 
   is => 'rw', 
   isa => 'Str', 
   lazy => 1, 
   default => sub { URI->new( shift->url)->host; }
);

has title => ( 
   is => 'rw', 
   isa => 'Str', 
   default => sub{'undefind page name'} 
);

has content => ( 
   is => 'rw', 
   isa => 'Str',
);

has [qw{local_links remote_links images}] => (
   is => 'rw',
   isa => 'ArrayRef',
   default => sub{[]},
);

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

