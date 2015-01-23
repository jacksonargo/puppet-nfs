# manifests/exports.pp
# Uses augeas to manage /etc/exports

define nfs::export ($share = $title, $clients, $options) {
    augeas { "$title" :
        context => "/files/etc/exports",
        changes => template( "nfs/exports.erb" )
    }
}

