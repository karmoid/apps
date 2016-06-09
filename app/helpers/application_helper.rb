module ApplicationHelper
  def humanize secs
    secs = secs / 60
    [[60, :min], [24, :h], [1000, :j]].inject([]){ |s, (count, name)|
      if secs > 0
        secs, n = secs.divmod(count)
        s.unshift "#{n.to_i} #{name}"
      end
      s
    }.join(' ')
  end

end
