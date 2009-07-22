require 'action_view/helpers/asset_tag_helper'

module Thematic
  # Thematic version
  VERSION = '0.1.0'
end

module ActionController
  class Base
    protected
      def render_with_thematic(options = nil, extra_options = {}, &block)
        theme = extra_options.delete(:thematic)
        
        if self.respond_to?(:thematic)
          theme ||= self.thematic
        end
        
        if theme
          prepend_view_path(File.join(RAILS_ROOT, 'themes', theme.to_s, 'views'))
        end
        
        if block
          render_without_thematic(options, extra_options) do
            block.call
          end
        else
          render_without_thematic(options, extra_options)
        end
      end
      
      alias_method_chain :render, :thematic
  end
end

module ActionView
  module Helpers #:nodoc:
    module AssetTagHelper
      def javascript_include_tag(*sources)
        options = sources.extract_options!.stringify_keys
        cache   = options.delete("cache")
        recursive = options.delete("recursive")

        if ActionController::Base.perform_caching && cache
          joined_javascript_name = (cache == true ? "all" : cache) + ".js"
          joined_javascript_path = File.join(javascripts_dir, joined_javascript_name)

          write_asset_file_contents(joined_javascript_path, compute_javascript_paths(sources, recursive)) unless File.exists?(joined_javascript_path)
          javascript_src_tag(joined_javascript_name, options)
        else
          expand_javascript_sources(sources, recursive).collect { |source| javascript_src_tag(source, options) }.join("\n")
        end
      end

      def stylesheet_link_tag(*sources)
        options = sources.extract_options!.stringify_keys
        cache   = options.delete("cache")
        recursive = options.delete("recursive")

        if ActionController::Base.perform_caching && cache
          joined_stylesheet_name = (cache == true ? "all" : cache) + ".css"
          joined_stylesheet_path = File.join(stylesheets_dir, joined_stylesheet_name)

          write_asset_file_contents(joined_stylesheet_path, compute_stylesheet_paths(sources, recursive)) unless File.exists?(joined_stylesheet_path)
          stylesheet_tag(joined_stylesheet_name, options)
        else
          expand_stylesheet_sources(sources, recursive).collect { |source| stylesheet_tag(source, options) }.join("\n")
        end
      end
      
      def image_tag(source, options = {})
        options.symbolize_keys!

        options[:src] = path_to_image(source)
        options[:alt] ||= File.basename(options[:src], '.*').split('.').first.to_s.capitalize

        if size = options.delete(:size)
          options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
        end

        if mouseover = options.delete(:mouseover)
          options[:onmouseover] = "this.src='#{image_path(mouseover)}'"
          options[:onmouseout]  = "this.src='#{image_path(options[:src])}'"
        end

        tag("img", options)
      end
      
      def javascript_include_tag(*sources)
        options = sources.extract_options!.stringify_keys
        cache   = options.delete("cache")
        recursive = options.delete("recursive")

        if ActionController::Base.perform_caching && cache
          joined_javascript_name = (cache == true ? "all" : cache) + ".js"
          joined_javascript_path = File.join(javascripts_dir, joined_javascript_name)

          write_asset_file_contents(joined_javascript_path, compute_javascript_paths(sources, recursive)) unless File.exists?(joined_javascript_path)
          javascript_src_tag(joined_javascript_name, options)
        else
          expand_javascript_sources(sources, recursive).collect { |source| javascript_src_tag(source, options) }.join("\n")
        end
      end

      private
        def compute_public_path(source, dir, ext = nil, include_host = true)
          has_request = @controller.respond_to?(:request)
          
          source_ext = File.extname(source)[1..-1]
          if ext && (source_ext.blank? || (ext != source_ext && File.exist?(File.join(assets_dir, dir, "#{source}.#{ext}"))))
            source += ".#{ext}"
          end

          if @controller.respond_to?(:theme) && @controller.theme
            dir = "#{dir}/#{@controller.theme}"
          end
          
          unless source =~ %r{^[-a-z]+://}
            source = "/#{dir}/#{source}" unless source[0] == ?/

            source = rewrite_asset_path(source)

            if has_request && include_host
              unless source =~ %r{^#{ActionController::Base.relative_url_root}/}
                source = "#{ActionController::Base.relative_url_root}#{source}"
              end
            end
          end

          if include_host && source !~ %r{^[-a-z]+://}
            host = compute_asset_host(source)

            if has_request && !host.blank? && host !~ %r{^[-a-z]+://}
              host = "#{@controller.request.protocol}#{host}"
            end

            "#{host}#{source}"
          else
            source
          end
        end

        def rails_asset_id(source)
          if asset_id = ENV["RAILS_ASSET_ID"]
            asset_id
          else
            if @@cache_asset_timestamps && (asset_id = @@asset_timestamps_cache[source])
              asset_id
            else
              path = File.join(assets_dir, source)
              asset_id = File.exist?(path) ? File.mtime(path).to_i.to_s : ''

              if @@cache_asset_timestamps
                @@asset_timestamps_cache_guard.synchronize do
                  @@asset_timestamps_cache[source] = asset_id
                end
              end

              asset_id
            end
          end
        end

        def expand_javascript_sources(sources, recursive = false)
          if sources.include?(:all)
            all_javascript_files = collect_asset_files(javascripts_dir, ('**' if recursive), '*.js')
            ((determine_source(:defaults, @@javascript_expansions).dup & all_javascript_files) + all_javascript_files).uniq
          else
            expanded_sources = sources.collect do |source|
              determine_source(source, @@javascript_expansions)
            end.flatten
            expanded_sources << "application" if sources.include?(:defaults) && File.exist?(File.join(javascripts_dir, "application.js"))
            expanded_sources
          end
        end

        def expand_stylesheet_sources(sources, recursive)
          if sources.first == :all
            collect_asset_files(stylesheets_dir, ('**' if recursive), '*.css')
          else
            sources.collect do |source|
              determine_source(source, @@stylesheet_expansions)
            end.flatten
          end
        end

        def asset_file_path(path)
          File.join(assets_dir, path.split('?').first)
        end
        
        def assets_dir
          @@assets_dir ||= defined?(Rails.public_path) ? Rails.public_path : "public"
        end
        
        def javascripts_dir
          @@javascripts_dir ||= "#{assets_dir}/javascripts"
        end
        
        def stylesheets_dir
          @@stylesheets_dir ||= "#{assets_dir}/stylesheets"
        end
    end
  end
end