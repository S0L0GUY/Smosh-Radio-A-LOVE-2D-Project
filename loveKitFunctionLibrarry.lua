local loveKit = {}

function loveKit.Start()

  function loveKit.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2 - y1)^2)
  end

  function loveKit.distanceBetweenX(x1, x2)
    return math.sqrt((x2-x1)^2)
  end

  function loveKit.distanceBetweenY(y1, y2)
    return math.sqrt((y2-y1)^2)
  end

end

return loveKit
