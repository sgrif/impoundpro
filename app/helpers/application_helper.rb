module ApplicationHelper
  def cp(paths)
    Array.wrap(paths).each do |path|
      return "active" if current_page?(path)
    end
    nil
  end

  def avatar_url(user)
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=mm"
  end
end
