package DisqusCommentSnippet::Tags;

use strict;
use warnings;
use MT::Template::Context;
use MT::Entry;

sub _hdlr_disqus {
    my ($ctx, $args) = @_;
    my ($permalink, $dqsShortname, $identifier, $disqus) = '';
    my $e = $ctx->stash('entry')
         or return $ctx->_no_entry_error();
    my $at = $ctx->{current_archive_type} || $ctx->{archive_type};
    return '' if $at =~ /^(Daily|Weekly|Monthly|Category)/;
    $permalink = $e->permalink;
    $permalink = MT::Util::strip_index( $permalink, $ctx->stash('blog') ) unless $args->{with_index};
    $identifier = $at eq 'Page' ? 'webpage: ' . $permalink 
                                : $e->id .': ' . $permalink;

    my $plugin = MT->component("DisqusCommentSnippet");
    my $scope = "blog:".$ctx->stash('blog_id');
    $dqsShortname = $plugin->get_config_value('mdc_dqsShortname',$scope);

    $disqus = <<"EOC";
<div id="disqus_thread"></div>
<script type="text/javascript">
    (function(){
        var disqus_shortname = '$dqsShortname'; // required: replace example with your forum shortname
        var disqus_url = '$permalink';
        var disqus_identifier = '$identifier';

        /* * * DON'T EDIT BELOW THIS LINE * * */
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript><p>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></p></noscript>
<p><a href="https://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a></p>
EOC
    return $disqus;
}

1;