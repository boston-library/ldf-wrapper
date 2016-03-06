## These tasks get loaded into the host application when jettywrapper is required
require 'yaml'

namespace :ldfjetty do
  JETTY_DIR = 'ldf-jetty'

  desc "download the jetty zip file"
  task :download do
    Ldfwrapper.download
  end

  desc "unzip the downloaded jetty archive"
  task :unzip do
    Ldfwrapper.unzip
  end


  desc "download and install the jetty zip file"
  task :install do
    Ldfwrapper.download
    Ldfwrapper.unzip
  end

  desc "remove the jetty directory and recreate it"
  task :clean do
    Ldfwrapper.clean
  end
  
  desc "Return the status of jetty"
  task :status => :environment do
    status = Ldfwrapper.is_jetty_running?(JETTY_CONFIG) ? "Running: #{Ldfwrapper.pid(JETTY_CONFIG)}" : "Not running"
    puts status
  end
  
  desc "Start jetty"
  task :start => :environment do
    Ldfwrapper.start(JETTY_CONFIG)
    puts "jetty started at PID #{Ldfwrapper.pid(JETTY_CONFIG)}"
  end
  
  desc "stop jetty"
  task :stop => :environment do
    Ldfwrapper.stop(JETTY_CONFIG)
    puts "jetty stopped"
  end
  
  desc "Restarts jetty"
  task :restart => :environment do
    Ldfwrapper.stop(JETTY_CONFIG)
    Ldfwrapper.start(JETTY_CONFIG)
  end


  desc "Load the jetty config"
  task :environment do
    unless defined? JETTY_CONFIG
      JETTY_CONFIG = Ldfwrapper.load_config
    end
  end

end

namespace :repo do



end
