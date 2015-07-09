function LayoutType()
    return {
        NONE        : "NONE"
        VERTICAL    : "VERTICAL"
        HORIZONTAL  : "HORIZONTAL"
    }
end function

function UILayout(options)
    id = random(1000000000, 9999999999).toStr()
    app = GetApp()
    this = UIBase({
        id      :   if_else(options.id <> invalid, options.id, id)
        x       :   if_else(options.x <> invalid, toInt(options.x), 0)
        y       :   if_else(options.y <> invalid, toInt(options.y), 0)
        z       :   if_else(options.z <> invalid, toInt(options.z), 0)
        width   :   if_else(options.width <> invalid, toInt(options.width), 0)
        height  :   if_else(options.height <> invalid, toInt(options.height), 0)
    })
    
    this.preLayout = {
        x       :   this.x
        y       :   this.y
        z       :   this.z
        width   :   this.width
        height  :   this.height
    }
    
    AddChildrenContainerTo(this)
    
    this.layout = function(onComplete = invalid, onCompleteContext = invalid)
        app = GetApp()
        
        m.setOpaque(false) 'Begin Layout
        
        
        
        m.setOpaque(true) 'End Layout
        
        if onComplete <> invalid
            onComplete(onCompleteContext)
        end if
        
        RefreshScreen()
    end function
    
    return this
end function