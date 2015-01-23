# Just for a baseline test you can call the class as a type.
#
# But this module is designed more for use with hiera, so put your parameters
# there and just include it.
#
# nfs::exports, nfs::export_defaults, nfs::mounts, and nfs::mount_defaults
# are optional hiera lookups.
#
# nfs::package and nfs::service are required unless given as parameters.

# include nfs
class { 'nfs' : package => 'nfs', service => 'nfsd' }
