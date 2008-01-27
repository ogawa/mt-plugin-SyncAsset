package SyncAsset;

#
# create_asset: create or update a single asset
# (This method doesn't depend on MT::App::CMS)
#
sub create_asset {
    my ($param) = @_;

    my $blog_id   = $param->{blog_id};
    my $user_id   = $param->{user_id};
    my $file_path = $param->{file_path};
    my $file_name = $param->{file_name};
    my $file_ext  = $param->{file_ext};
    my $url       = $param->{url};
    my $label     = $param->{label} || $param->{file_name};
    my $bytes     = -s $file_path;

    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);

    require MT::Asset;
    my $asset_pkg = MT::Asset->handler_for_file($file_name);

    # calculate ($w, $h, $id) and $is_image
    my ($w, $h, $id);
    if ($asset_pkg->isa('MT::Asset::Image')) {
	eval { require Image::Size; };
	die MT->translate("Perl module Image::Size is required to determine width and height of uploaded images.") if $@;
	($w, $h, $id) = Image::Size::imgsize($file_path);
    }
    my $is_image = defined($w) && defined($h);

    # shorten file_path and url
    my $site_url = $blog->site_url;
    my $site_path = $blog->site_path;
    $file_path =~ s!$site_path!%r!;
    $url =~ s!$site_url!%r/!;

    my $asset = $asset_pkg->load({
	file_path => $file_path,
	blog_id => $blog_id,
    });
    if (!$asset) {
	$asset = $asset_pkg->new();
	$asset->file_path($file_path);
	$asset->file_name($file_name);
	$asset->file_ext($file_ext);
	$asset->blog_id($blog_id);
	$asset->created_by($user_id);
    } else {
	$asset->modified_by($user_id);
    }
    $asset->url($url);
    $asset->label($label);
    if ($is_image) {
	$asset->image_width($w);
	$asset->image_height($h);
    }
    #$asset->mime_type($mimetype) if $mimetype;
    $asset->save or die $asset->errstr;
    1;
}

1;
