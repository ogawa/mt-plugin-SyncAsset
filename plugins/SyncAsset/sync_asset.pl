# SyncAsset
#
# $Id$
#
# This software is provided as-is. You may use it for commercial or 
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2008 Hirotaka Ogawa


package MT::Plugin::SyncAsset;
use strict;
use base qw(MT::Plugin);

use MT 4.0;

our $VERSION = '0.01';

my $plugin = __PACKAGE__->new({
    id => 'sync_asset',
    name        => 'SyncAsset',
    version     => $VERSION,
    description => '<__trans phrase="SyncAsset allows you to synchronize all assets in your directory with MT asset database.">',
    doc_link    => 'http://code.as-is.net/public/wiki/SyncAsset',
    author_name => 'Hirotaka Ogawa',
    author_link => 'http://as-is.net/blog/',
    version     => $VERSION,
    l10n_class  => 'SyncAsset::L10N',
});
MT->add_plugin($plugin);

sub instance { $plugin }

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
	applications => {
	    cms => {
		methods => {
		    'sync_asset_start' => 'SyncAsset::CMS::sync_asset_start',
		    'sync_asset'       => 'SyncAsset::CMS::sync_asset',
		}
	    }
	},
	callbacks => {
	    'MT::App::CMS::template_source.list_asset' => 'SyncAsset::CMS::transform_list_asset',
	},
    });
}

1;
