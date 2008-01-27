# $Id$
package SyncAsset::L10N::ja;

use strict;
use base 'SyncAsset::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'SyncAsset allows you to synchronize all assets in your directory with MT asset database.' => 'SyncAssetを使うと、指定したディレクトリにある全アイテムと、Movable Typeのアイテムデータを同期することができます。',
    'Sync Asset' => 'アイテムを同期',
    'Path' => 'パス',
    'Enter the full path of the directory you want to synchronize.' => '同期したいディレクトリをフルパスで入力',
    'Enter the corresponding URL for the above path.' => '上記のパスに対応するURLを入力',
    'Sync' => '同期する',
    "File '[_1]' added." => "ファイル「[_1]」を追加しました。",
    "File '[_1]' failed to add." => "ファイル「[_1]」の追加に失敗しました。",
);

1;
