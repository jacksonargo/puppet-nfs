# manifests/exports.pp
# Uses augeas to manage /etc/exports

define nfs::export ($clients, $options, $share = $title) {
    augeas { "${title}-export" :
        context => '/files/etc/exports',
        changes => template( 'nfs/exports.erb' )
    }
}

