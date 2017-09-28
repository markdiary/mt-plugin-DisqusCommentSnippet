<?php 
function smarty_function_mtdisquscommentsnippet($args, &$ctx) {

    $mt = MT::get_instance();
    $blog_id = 'blog:' . $ctx->stash('blog_id');
    $blog_config = $mt->db()->fetch_plugin_data('DisqusCommentSnippet','configuration:' . $blog_id);
    $dsqShortname = $blog_config['mdc_dqsShortname'];

    $e = $ctx->stash('entry');
    $at = $ctx->stash('current_archive_type');
    if($at==='Individual'){
            $permalink = $ctx->tag('EntryPermalink');
            $eid = $ctx->tag('EntryID');
            $identifier = $eid .': '. $permalink;
        } elseif ($at==='Page'){
            $permalink = $ctx->tag('PagePermalink');
            $identifier = 'webpage: ' . $permalink;
        } else { return '';}


$disqus = <<<EOC
<div id="disqus_thread"></div>
<script type="text/javascript">
    (function(){
        var disqus_shortname = '$dsqShortname'; // required: replace example with your forum shortname
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
EOC;

    return ($disqus);
}
?>