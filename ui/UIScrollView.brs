
' The MIT License (MIT)

' Copyright (c) 2015 Karim Kawambwa

' Author Karim Kawambwa

' Permission is hereby granted, free of charge, to any person obtaining a copy
' of this software and associated documentation files (the "Software"), to deal
' in the Software without restriction, including without limitation the rights
' to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
' copies of the Software, and to permit persons to whom the Software is
' furnished to do so, subject to the following conditions:

' The above copyright notice and this permission notice shall be included in
' all copies or substantial portions of the Software.

' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
' OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
' THE SOFTWARE.

function UIScrollView(options, appendOptions = {} as Object)
    this = UIView(options, {
        type : "scrollview"
        scrolling : "-"
        scrollingTaskId : invalid
        content : {
            view : invalid
            offset : {
                x : 0
                y : 0
            }
        }
    })

    'Other Views options subclassing
    if appendOptions <> invalid then this.Append(appendOptions) 
    
    this.content.view = this
    
    ' @Override UIVIew init
    this.base_view_Init = this.init
    this.init = function()
        m.base_view_Init()
    end function
    
    this.content.height = function()
        m.largestYPos = 0
        m.largestYHeight = 0
        
        m.view.children["each"](m, function(index, child, m)
            if (child.y() - m.offset.y) + child.height()  >= m.largestYPos + m.largestYHeight then
                m.largestYPos = child.y() - m.offset.y
                m.largestYHeight = child.height()
            end if
        end function)
        
        if (m.largestYPos + m.largestYHeight) < m.view.height() then return m.view.height()
        
        return m.largestYPos + m.largestYHeight
    end function
    
    this.content.width = function()
        m.largestXPos = 0
        m.largestXWidth = 0
        
        m.view.children["each"](m, function(index, child, m)
            if (child.x() - m.offset.x) + child.width()  >= m.largestXPos + m.largestXWidth then
                m.largestXPos = child.x() - m.offset.x
                m.largestXWidth = child.width()
            end if
        end function)
        
        if (m.largestXPos + m.largestXWidth) < m.view.width() then return m.view.width()
        
        return m.largestXPos + m.largestXWidth
    end function
    
    this.content.applyOffset = function(x, y)
        m.offset.x = m.offset.x + x
        m.offset.y = m.offset.y + y
    end function
    
    this.scrollToTop = function()
    end function
    
    this.scrollToBottom = function()
    end function
    
    this.scrollToLeft = function()
    end function
    
    this.scrollToRight = function()
    end function
    
    this.scrollOffset = function(x, y, animated = true as Boolean)
        ' TODO: animated
        final = m.content.offset.y + y + m.height()
        if final > m.content.height()
            y = m.content.height() - (m.content.offset.y + m.height())
        else if final < 0
            y = (m.content.offset.y + m.height())
        end if
        
        final = m.content.offset.x + x + m.width()
        if final > m.content.width()
            x = m.content.width() - (m.content.offset.x + m.width())
        else if final < 0
            x = (m.content.offset.x + m.width())
        end if
        
        m.content.applyOffset(x, y)
        m.children["each"]([x,y], function(index, child, args)
            x = args[0]
            y = args[1]
            
            child.setX(child.x() + x)
            child.setY(child.y() + y)
        end function)
        Layout(m)
        RefreshScreen()
    end function
    
    this.shouldHandleUserInput = function(code)
        return true
    end function
    
    this.shouldAcceptFocus = function(code) as Boolean
        return true
    end function
    
    this.shouldReleaseFocus = function(code) as Boolean
        return (code = 3 and m.hitBottom()) or (code = 2 and m.hitTop())
    end function
    
    this.onInteractionEvent = function(msg)
        if msg = 2 ' up pressed
            if not m.hitTop()
                m.scrolling = "up"
                m.createScrollingTaskWithOffset(0, 2)
            end if
        else if msg = 3 ' down pressed
            if not m.hitBottom()
                m.scrolling = "down"
                m.createScrollingTaskWithOffset(0, -2)
            end if
        else if msg = 103 or  msg = 102 ' down released  up released
            m.scrolling = "-"
            KillTask(m.scrollingTaskId)
        end if
        
        return false 'not handled
    end function
    
    this.createScrollingTaskWithOffset = function(x, y)
        m.scrollingTaskId = ScheduleTask({
            delay : 0 'perform immediately
            arg : [m, x, y]
            callback : function(args)
                m = args[0]
                x = args[1]
                y = args[2]
                
                m.scrollOffset(x, y)
                
                if m.scrolling = "down" then 
                    return m.hitBottom()
                else if m.scrolling = "up" then
                    return m.hitTop()
                end if
            end function
            onStateChangeArg : m
            onStateChange : function(state, onStateChangeArg)
                m = onStateChangeArg
                
                if state = "willstart"
                else if state = "cancelled"
                else if state = "done"
                end if
            end function
        })
    end function
    
    this.onFocus = function()
        
    end function
    
    this.onBlur = function()
        
    end function
    
    ' helpers
    
    this.hitTop = function() as Boolean
        return m.content.offset.y >= 0
    end function
    
    this.hitBottom = function() as Boolean
        return abs(m.content.offset.y) + m.height() >= m.content.height()
    end function
    
    return this
end function