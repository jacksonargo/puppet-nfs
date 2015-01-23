# manifests/init.pp
# Installs nfs package
# Starts nfs servicei
# Manages exports in /etc/exports
# Manages nfs mounts in /etc/fstab

class nfs ($package, $service) {

    $mounts = hiera_hash('nfs::mounts', {})
    $exports = hiera_hash('nfs::exports', {})
    $mount_defaults = hiera_hash('nfs::mount_defaults', {})
    $export_defaults = hiera_hash('nfs::export_defaults', {})
    $mountpoints = keys($mounts)

    # Install
    package { $package : ensure => 'present' }

    # Run
    service { $service : ensure => running }

    # Create the nfs mounts and mount points
    if $mounts != {} {
        file { $mountpoints : ensure => directory }
        create_resources(mount, $mounts, hiera_hash('nfs::mounts_defaults')) 
    }
    else { info ("No mounts found for $::hostname.") }

    # Create the nfs exports
    if $exports != {} { create_resources(nfs::export, $exports, hiera_hash('nfs::exports_defaults')) }
    else { info ("No exports found for $::hostname.") }

    # Refresh the exports list
    exec { '/usr/sbin/exportfs -ra': refreshonly => true, path => '/bin:/sbin:/usr/bin:/usr/sbin' }

    Nfs::Export <||> ~> Exec['exportfs -ra']
    Package <| tag == "nfs" |> -> Service <| tag == "nfs" |>
}

