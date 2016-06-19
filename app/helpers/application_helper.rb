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

  def self.concatener_dataset(dataset1, dataset2)
    if dataset2.nil?
      dataset1
    else
      dataset1+dataset2
    end
  end

  def concatener_dataset (dataset1, dataset2)
    ApplicationHelper.concatener_dataset(dataset1, dataset2)
  end

end
