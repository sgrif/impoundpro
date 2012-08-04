module ApplicationHelper
  def cp(paths)
    Array.wrap(paths).each do |path|
      return "active" if current_page?(path)
    end
    nil
  end
end
