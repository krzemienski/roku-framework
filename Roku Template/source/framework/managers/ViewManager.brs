function CreateUI(type_, options) as Object
    ui = {
        button      : UIButton
        label       : UILabel
        image       : UIImage
        textArea    : UITextArea
        view        : UIView
        gridView    : UIGridView
        listView    : UIListView
        scrollView  : UIScrollView
    }
    
    return ui[type_](options)
end function

function LoadViewNamed(viewName, displaySpecific = false as Boolean)
    app = GetApp()
    
    xmlString = ReadAsciiFile(app.viewFolder.Default+viewName+".xml")
    xml = ParseXML(xmlString)
    
    loadedView = CreateUI(xml.GetName(), xml.GetAttributes())
    
    LoadChildrenForView(loadedView, xml)
    
    return loadedView
end function

function LoadChildrenForView(parentView, parentXml)
    childrenXml = parentXml.getbody()
    if childrenXml <> invalid
        for each childXml in childrenXml
            view = CreateUI(childXml.GetName(), childXml.GetAttributes())
            
            if view = invalid then return false
            
            LoadChildrenForView(view, childXml)
            parentView.addChild(view)
        end for
    end if
    
    return true
end function

function ParseXML(str As String) As Dynamic
    if str = invalid return invalid
    xml = CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
end function