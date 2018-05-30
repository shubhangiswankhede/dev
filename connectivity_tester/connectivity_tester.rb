require 'rubyXL'
require 'socket'
require 'net/ssh'
require 'timeout'
require 'thread'
require 'thread/pool'
require 'resolv'
require "stringio"
require 'ruby-progressbar'

$ip_regex = /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
$failed = []
$passed = []
$unable = []
$password = ENV['PASSWORD']
$user = ENV['USERNAME']
$filename = "list.xlsx"

$src_col = 0
$dst_col = 1
$port_col = 4

pool = Thread.pool(20)

workbook = RubyXL::Parser.parse($filename).worksheets
$items = []

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def yellow(text); colorize(text, 33); end

def get_items(row)
  items_list = []
  if row[$src_col] =~ $ip_regex && row[$dst_col] =~ $ip_regex
    row[$src_col].scan($ip_regex).each do |src|
      unless src =~ /\.0{1}$/
        row[$dst_col].scan($ip_regex).each do |dst|
          row[$port_col].to_s.scan(/(\d+)/).each do |port|
            items_list << {:src => src, :dst => dst, :port => port[0]}
          end
        end
      end
    end
  end
  return items_list
end

def conn_check(conn)
    ##Attempt to resolve the IP to a DNS name to avoid NATed IP issues
    ssh_src = nil
    nat_src = nil
    begin
      ssh_src = Resolv.getname conn[:src]
    rescue Resolv::ResolvError => e
      begin
        ##The attempt to resolve the DNS name from the IP address failed, so attempt to resolve using the NATed IP address
        if conn[:src].start_with?("10.")
          nat_src = conn[:src].sub(/\A10./, "11.")
        end
        ssh_src = Resolv.getname nat_src
      rescue Resolv::ResolvError => e
        ##Both attemps to resolve the DNS name from the IP address failed, so just ssh using the IP address
        ssh_src = conn[:src]
      end
    end

    ##Check if previous attempts to SSH to src failed
    if !($unable.any? {|unable_conn| unable_conn[:src] == conn[:src]})
      begin

      ssh = Net::SSH.start(ssh_src, \
        $user, :password => $password, \
        :timeout => 10, :verify_host_key => false)

      ##Open a tcp connection to the destination host on the specified port
      ##Time out after 3 second
      rtn = nil
      begin
        Timeout::timeout(10) do
          rtn = ssh.exec!("bash -c 'exec 3<> /dev/tcp/#{conn[:dst]}/#{conn[:port]}'; echo $?")
        end
      rescue Timeout::Error => e
        rtn = 'timeout'
        ssh.shutdown!
      end

      if rtn =~ /0$/
        $passed << conn
      elsif rtn =~ /Connection refused/
        $passed << conn
      elsif rtn =~ /timeout/
        conn[:error] = 'Connection to destination machine timed out.'
        $failed << conn
      elsif rtn =~ /No route to host/
        conn[:error] = 'No route to destination machine.'
        $failed << conn
      else
        conn[:error] = 'Unknown.'
        $failed << conn
      end

      if !ssh.closed?
        ssh.close
      end

      rescue Exception => e
        conn[:"#{e.class}"] = e.message
        $unable << conn
      end
    else
      conn[:error] = 'Skipping test because previous attempts to SSH to source machine failed.'
      $unable << conn
    end
end


workbook.each do |worksheet|
  worksheet.extract_data.each do |row|
    $items.concat(get_items row)
  end
end

if $items.empty?
  puts red("Found 0 connections to test.  Please check the spreadsheet formatting")
  exit(1)
end

STDOUT.sync = true
puts "Testing #{$items.length} connections..."

item_index = 0
percentage = 10
$items.each do |item|
  pool.process {
    if (item_index.to_f / $items.length.to_f * 100.0) >= percentage
      puts "Testing #{percentage}% complete..."
      percentage += 10
    end
    item_index += 1
    conn_check(item)
  }
end
pool.shutdown
STDOUT.sync = false

if $passed.size > 0
  $passed.sort! { |a, b| a.flatten.join(" ") <=> b.flatten.join(" ")}
  puts "Successful on #{$passed.length} Connectivity checks:"
  $passed.each do |item|
    puts green(item.flatten.join(" "))
  end
end

if $unable.size > 0
  $unable.sort! { |a, b| a.flatten.join(" ") <=> b.flatten.join(" ")}
  puts "Unable to Check #{$unable.length} ( Unable to SSH to the source machine) :"
  $unable.each do |item|
    puts yellow(item.flatten.join(" "))
  end
end

if $failed.size > 0
  $failed.sort! { |a, b| a.flatten.join(" ") <=> b.flatten.join(" ")}
  puts "Failed on #{$failed.length} checks:"
  $failed.each do |item|
    puts red(item.flatten.join(" "))
  end
end

if $unable.size > 0 || $failed.size > 0
  exit(1)
end
