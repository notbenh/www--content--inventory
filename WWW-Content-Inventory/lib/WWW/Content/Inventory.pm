package WWW::Content::Inventory;
use Moose;
use WWW::Content::Inventory::Page;

=head1 NAME

WWW::Content::Inventory - The great new WWW::Content::Inventory!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Build a tree-based sitemap of a given ULR.

Inspired by : 
"Doing a Content Inventory" by I<Jeffrey Veen> 

L<http://adaptivepath.com/ideas/essays/archives/000040.php>

Perhaps a little code snippet.

    use WWW::Content::Inventory;

    my $ci = WWW::Content::Inventory->new();
    $ci->snarf($my_url);
    ...

=cut

has Pages => ( 
   is => 'rw', 
   isa => 'HashRef', 
   default => sub { {} },
);

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 snarf

  snarf('http://my.url');

=cut

sub snarf {
   my ($self, $url) = @_;

printf(qq{[PAGE] %s \n},$url);

   #what can we find out about $url?
   my $p = WWW::Content::Inventory::Page->new( url => $url )->snarf;
   
   #store everything that we found.
   $self->Pages->{$url} = $p;

   #look at every local link for $url to spider out.
   for my $link ( @{ $p->local_links } ) {
      if ( ! defined $self->Pages->{$link->{url}} ) {
         $self->snarf( $link->{url} );
      }
   }

   return $self;
}

=head2 function2

=cut

sub function2 {
}


=head1 TODO

- it would be nice to have a 'report' 
- Idealy I would rather push to some DB backend (SQLite?)
- please add an exclude/ignore regex option


=head1 AUTHOR

ben hengst, C<< <NOTBENH at CPAN.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-content-inventory at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Content-Inventory>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Content::Inventory


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Content-Inventory>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Content-Inventory>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Content-Inventory>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Content-Inventory>

=back


=head1 ACKNOWLEDGEMENTS

Stacey Anderson for presenting me with the problem to solve.

=head1 COPYRIGHT & LICENSE

Copyright 2008 ben hengst, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of WWW::Content::Inventory
