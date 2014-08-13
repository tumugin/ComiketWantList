require 'resolv'
require 'pp'

class MailAddressValidator
  def self.validate(address)
    return validate_by_regex(address) && validate_by_MX(address)
  end
  def self.validate_by_regex(address)
    addr_spec = %r{^(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+/=?\^`{}~|\-]+))*)|(?:"(?:\\[^\r\n]|[^\\"])*")))\@(?:(?:(?:(?:[a-zA-Z0-9_!#\$\%&'*+/=?\^`{}~|\-]+)(?:\.(?:[a-zA-Z0-9_!#\$\%&'*+/=?\^`{}~|\-]+))*)|(?:\[(?:\\\S|[\x21-\x5a\x5e-\x7e])*\])))$}
    address =~addr_spec
  end
  def self.validate_by_MX(address)
      mxdomain = address[/[^@]+$/]
      Resolv::DNS.new.getresource(mxdomain,Resolv::DNS::Resource::IN::MX) rescue nil
  end
  private_class_method :validate_by_regex, :validate_by_MX
end