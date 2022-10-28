#!/usr/bin/env rake

require 'rubygems'
require './build-scripts/build'
require './build-scripts/download'
require './build-scripts/cordova'


task :clean do
  FileUtils.remove_dir $out_dir
end

task :'init-all' do
  initDirs
  downloadRevealJS
  downloadDecktape
end

task :init do
  initDirs
  downloadRevealJS
end

task :'build-all' do
  buildRevealJS
  buildSlidesPdf
  buildAsciiDocHtml
  buildAsciidocPdf
end

task :'build-revealjs' do
  buildRevealJS
end

task :build => :'build-revealjs'

## Cordova related

task :'init-cordova' do
  installCordova
end

task :'init-cordova' do
  initCordova
end

task :'build-cordova' do
  buildCordova
end

task :'run-cordova' do
  runCordova
end
