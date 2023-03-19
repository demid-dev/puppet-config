# Install httpd package
package { 'httpd':
  ensure => installed,
}

# Create document root directory
file { '/var/www/html':
  ensure  => directory,
  owner   => 'apache',
  group   => 'apache',
  mode    => '0755',
  require => Package['httpd'],
}

# Create index.html file
file { '/var/www/html/index.html':
  ensure  => file,
  content => '<html><body><h1>Hello, world!</h1></body></html>',
  owner   => 'apache',
  group   => 'apache',
  mode    => '0644',
  require => File['/var/www/html'],
}

# Configure httpd service
service { 'httpd':
  ensure  => running,
  enable  => true,
  require => Package['httpd'],
}
