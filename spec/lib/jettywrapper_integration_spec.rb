require 'spec_helper'
require 'rubygems'
require 'uri'
require 'net/http'
require 'socket'

  describe Ldfwrapper do
    context "integration" do
      before(:all) do
        $stderr.reopen("/dev/null", "w")
        Ldfwrapper.logger.level=3
      end
      
      it "starts" do
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty"),
          :startup_wait => 90,
          :java_opts => ["-Xmx256m", '-XX:MaxPermSize=256m'],
          :jetty_port => TEST_JETTY_PORTS.first
        }
        Ldfwrapper.configure(jetty_params)
        ts = Ldfwrapper.instance
        ts.logger.debug "Stopping jetty from rspec."
        ts.stop
        ts.start      
        ts.logger.debug "Jetty started from rspec at #{ts.pid}"
        pid_from_file = File.open( ts.pid_path ) { |f| f.gets.to_i }
        expect(ts.pid).to eql(pid_from_file)
      
        # Can we connect to solr?
        require 'net/http' 
        response = Net::HTTP.get_response(URI.parse("http://localhost:#{jetty_params[:jetty_port]}/blaczegraph/"))
        expect(response.code).to eql("200")
        ts.stop
      
      end
      
      it "won't start if it's already running" do
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty"),
          :startup_wait => 90,
          :java_opts => ["-Xmx256m", '-XX:MaxPermSize=256m'],
          :jetty_port => TEST_JETTY_PORTS.first
        }
        Ldfwrapper.configure(jetty_params)
        ts = Ldfwrapper.instance
        ts.logger.debug "Stopping jetty from rspec."
        ts.stop
        ts.start
        ts.logger.debug "Jetty started from rspec at #{ts.pid}"
        response = Net::HTTP.get_response(URI.parse("http://localhost:#{jetty_params[:jetty_port]}/solr/"))
        expect(response.code).to eql("200")
        expect { ts.start }.to raise_exception(/Server is already running/)
        ts.stop
      end
      
      describe "is_port_in_use?" do
        describe "when a server is running on the port" do
          before do
            @s = TCPServer.new('127.0.0.1', TEST_JETTY_PORTS.last)
          end
          after do
            @s.close
          end
          it "can check to see whether a port is already in use" do
            expect(Ldfwrapper.is_port_in_use?(TEST_JETTY_PORTS.last)).to eql(true)
          end
        end
        it "should be false when nothing is running" do
          expect(Ldfwrapper.is_port_in_use?(TEST_JETTY_PORTS.last)).to eql(false)
        end
      end
      
      it "raises an error if you try to start a jetty that is already running" do
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty"),
          :jetty_port => TEST_JETTY_PORTS.first,
          :startup_wait => 30
        }
        ts = Ldfwrapper.configure(jetty_params)
        ts.stop
        expect(ts.pid_file?).to eql(false)
        ts.start
        expect{ ts.start }.to raise_exception
        ts.stop
      end

      it "raises an error if you try to start a jetty when the port is already in use" do
        jetty_params = {
          :jetty_home => File.expand_path("#{File.dirname(__FILE__)}/../../jetty"),
          :jetty_port => TEST_JETTY_PORTS.first,
          :startup_wait => 30
        }
	      socket = TCPServer.new(TEST_JETTY_PORTS.first)
        begin
          ts = Ldfwrapper.configure(jetty_params)
          ts.stop
          expect(ts.pid_file?).to eql(false)
          expect{ ts.start }.to raise_exception
          ts.stop
        ensure
          socket.close
        end
      end

      describe "#check_java_version!" do
        it "should check for a required minimum version of java" do
          expect(Ldfwrapper.check_java_version!("java", ">= 1.2")).to eq true
        end

        it "should raise an exception if java can't be found" do
          expect { Ldfwrapper.check_java_version!("/bin/cat", ">= 1.2") }.to raise_error /Java not found/
        end

        it "should raise an exception if the version of java is not new enough" do
          expect { Ldfwrapper.check_java_version!("java", ">= 999.999") }.to raise_error /999.999 is required to run Jetty/
        end
      end
    end
  end
