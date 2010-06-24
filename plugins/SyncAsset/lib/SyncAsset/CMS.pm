package SyncAsset::CMS;
use strict;
use SyncAsset;

sub sync_asset_start {
    my $app = shift;
    my $plugin = MT::Plugin::SyncAsset->instance;
    my $tmpl = $plugin->load_tmpl('sync_asset.tmpl');
    $app->build_page($tmpl);
}

sub sync_asset {
    my $app = shift;
    return $app->trans_error("Permission denied.")
	unless $app->user->is_superuser;
    $app->validate_magic() or return;

    my $plugin = MT::Plugin::SyncAsset->instance;

    my $q = $app->param;
    my $base_path = $q->param('base_path');
    my $base_url  = $q->param('base_url');
    $base_url .= '/' unless $base_url =~ m!/$!;
    my $blog_id = $q->param('blog_id');

    my (@success_loop, @error_loop);

    require File::Find::Rule;
    require File::Spec;
    require File::Basename;
    for my $file (File::Find::Rule->relative->file->in($base_path)) {
	my $file_path = File::Spec->catfile($base_path, $file);
	my $file_name = File::Basename::basename($file);
	my($file_ext) = $file =~ /\.([^.]*)$/;
	my $url = $file;
	$url =~ s!\\!/!g;
	$url =~ s!^/!!;
	$url = $base_url . $url;
	if (SyncAsset::create_asset({
	    file_path => $file_path,
	    file_name => $file_name,
	    file_ext  => $file_ext,
	    url       => $url,
	    blog_id   => $blog_id,
	    user_id   => $app->user->id,
	})) {
	    push @success_loop, {
		message => $plugin->translate("File '[_1]' added.", $file)
	    };
	} else {
	    push @error_loop, {
		message => $plugin->translate("File '[_1]' failed to add.", $file)
	    };
	}
    }
    if (!scalar @success_loop) {
	push @error_loop, {
	    message => $plugin->translate("No assets found.")
	};
    }

    my $tmpl = $plugin->load_tmpl('sync_asset.tmpl');
    $app->build_page($tmpl, {
	base_path => $base_path,
	base_url  => $base_url,
	complete  => 1,
	@success_loop ? (success_loop => \@success_loop) : (),
	@error_loop   ? (error_loop   => \@error_loop  ) : (),
    });
}

sub transform_list_asset {
    my ($cb, $app, $tmpl) = @_;
    my $plugin = MT::Plugin::SyncAsset->instance;
    my $q = $app->param;
    if ($q->param('blog_id')) {
	my $old = quotemeta(q{<$mt:include name="include/header.tmpl" id="header_include"$>});
#	my $new = q{<mt:setvarblock name="content_header" append="1"><p class="create-new-link"><a class="icon-left icon-create" onclick="return openDialog(null, 'sync_asset_start', 'blog_id=<mt:var name="blog_id">')" href="javascript:void(0)">} . $plugin->translate("Sync Asset") . q{</a></p></mt:setvarblock>};
	my $new = q{<mt:setvarblock name="content_header" append="1"><ul><li><a class="icon-left icon-create" onclick="return jQuery.fn.mtDialog.open('<mt:var name="script_url">?__mode=sync_asset_start&amp;blog_id=<mt:var name="blog_id">')" href="javascript:void(0)">} . $plugin->translate("Sync Asset") . q{</a></li></ul></mt:setvarblock>};
	$$tmpl =~ s/($old)/$new$1/;
    }
}

1;
