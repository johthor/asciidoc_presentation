require 'rubygems'
require 'bundler/setup'
require './config'
require './build-scripts/extensions'
require 'asciidoctor'
require 'asciidoctor-pdf'
require 'asciidoctor-revealjs'
require 'asciidoctor-diagram'

def buildRevealJS
  print "Building reveal.js as '#{$revealjs_out_file}' ...\n"
  FileUtils.mkpath $revealjs_out_dir
  FileUtils.copy_entry "lib/reveal.js-#{$revealjs_version}", "#{$revealjs_out_dir}/reveal.js"
  FileUtils.copy_entry "#{$image_dir}", "#{$revealjs_out_dir}/static"
  FileUtils.copy_entry "#{$video_dir}", "#{$revealjs_out_dir}/static"
  FileUtils.copy_entry "#{$generated_images_dir}", "#{$revealjs_out_dir}/static"
  FileUtils.copy_entry "#{$custom_config_dir}", "#{$revealjs_out_dir}/config"
  attributes = "imagesdir=static revealjsdir=reveal.js revealjs_theme=#{$theme} customcss=config/revealjs.css"
  attributes += $custom_attributes
  Asciidoctor.convert_file "#{$index_file}", backend: 'revealjs', safe: :unsafe,
                           to_file: "#{$revealjs_out_file}", :attributes => attributes
end

def buildAsciiDocHtml
  print "Building asciidoc html...\n"
  FileUtils.mkpath $html_out_dir
  FileUtils.copy_entry "#{$image_dir}", "#{$html_out_dir}/static"
  FileUtils.copy_entry "#{$video_dir}", "#{$html_out_dir}/static"
  Asciidoctor.convert_file "#{$index_file}", safe: :unsafe, to_file: "#{$html_out_file}", :attributes => "imagesdir=static" + $custom_attributes
end

def buildAsciidocPdf
  print "Building asciidoc pdf...\n"
  FileUtils.mkpath $asciidoc_pdf_out_dir
  FileUtils.mkpath $pdf_images_dir
  FileUtils.copy_entry "#{$image_dir}", "#{$pdf_images_dir}"
  FileUtils.copy_entry "#{$video_dir}", "#{$pdf_images_dir}"
  FileUtils.copy_entry "#{$generated_images_dir}", "#{$pdf_images_dir}"
  Asciidoctor.convert_file "#{$index_file}", safe: :unsafe, to_file: "#{$asciidoc_pdf_out_file}", backend: 'pdf', :attributes => "imagesdir=#{$project_dir_escaped + '/' + $pdf_images_dir} allow-uri-read" + $custom_attributes
end

def buildSlidesPdf
  print "Building slides pdf...\n"
  FileUtils.mkpath $slides_pdf_out_dir
  %x(cd lib/decktape-#{$decktape_version} && node decktape.js file://#{$project_dir_escaped + '/' + $revealjs_out_file} #{$project_dir_escaped + '/' + $slides_pdf_file})
end
