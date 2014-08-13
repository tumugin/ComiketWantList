require 'digest/sha2'

class UserController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def CreateUser
        user = User.new()
        user.Name = params[:name]
        user.UserID = params[:userid]
        user.Password = Digest::SHA512.hexdigest(params[:password])
        user.MailAdress = params[:mailadress]
        #This is test
        #test = UserWantList.new()
        #test.Name = "天使ちゃんマジ天使"
        #test2 = Item.new()
        #test2.Name = "あずにゃん"
        #test.Item << test2
        #user.UserWantList << test
        respond_to do |format|
            #Check values
            if params[:name].blank? | params[:mailadress].blank? | params[:password].blank? | params[:userid].blank?
                format.json{render:json => {"StatusCode" => "PARAMS_EMPTY" , "Status" => "Some param is empty."}}
                next
            end
            if params[:password].length < 6
                format.json{render:json => {"StatusCode" => "PASSORD_TOO_SHORT" , "Status" => "Password is too short."}}
                next
            end
            if !MailAddressValidator.validate(params[:mailadress])
                format.json{render:json => {"StatusCode" => "INVALID_MAIL_ADRESS" , "Status" => "Invalid mail adress."}}
                next
            end
            if SearchUser(params[:userid]) == nil && SearchMailAdress(params[:mailadress]) == nil
                if user.save
                    format.json{render:json => {"StatusCode" => "OK" , "Status" => "Create OK."}}
                else
                    format.json{render:json => {"StatusCode" => "SERVER_ERROR" , "Status" => "User create failed on server error."}}
                end
            else
                format.json{render:json => {"StatusCode" => "USER_DUPLICATE" , "Status" => "Dupulicated username or password"}}
            end
        end
    end

    def AuthUser
        respond_to do |format|
            user = User.where(UserID: params[:userid]).first
            if user != nil
                #user found
                if user.AuthPassword(params[:password])
                    #Auth OK
                    format.json{render:json => {"StatusCode" => "OK" , "Status" => "Auth OK."}}
                else
                    #Password incorrect
                    format.json{render:json => {"StatusCode" => "WRONG_PASSWORD" , "Status" => "Password is wrong."}}
                end
            else
                #user not found
                format.json{render:json => {"StatusCode" => "USER_NOT_FOUND" , "Status" => "User not found."}}
            end
        end
    end

    def AddWantList
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:name].blank?
            #Auth OK, add want list
            list = UserWantList.new()
            list.Name = params[:name]
            user.UserWantList << list
            user.save()
            status = {"StatusCode" => "OK" , "Status" => "want list create OK."}
        else
            #Auth NG
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def GetWantList
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password])
            status = {"StatusCode" => "OK" , "Status" => "get list ok.", "Lists" => user.UserWantList}
        else
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def EditWantList
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:listid].blank?
            #edit
            list = user.UserWantList.where(_id: params[:listid]).first
            #request
            if list == nil
                status = {"StatusCode" => "ITEM_NOT_FOUND" , "Status" => "item not found"}
            elsif request.post?
                list.Name = params[:name] if !params[:name].blank?
                list.save
                status = {"StatusCode" => "OK" , "Status" => "item edit OK"}
            elsif request.delete?
                #item delete
                list.destroy
                status = {"StatusCode" => "OK" , "Status" => "item delete OK"}
            else
                #Unknown
                status = {"StatusCode" => "UNKNOWN_REQUEST" , "Status" => "unknown request??"}
            end
        else
            #Auth error
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def AddItemToWantList
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:listid].blank? && !params[:itemName].blank?
            item = Item.new()
            item.Name = params[:itemName] if !params[:itemName].blank?
            item.Price = params[:itemPrice].to_i if !params[:itemPrice].blank?
            item.Description = params[:itemDescription] if !params[:itemDescription].blank?
            item.Circle = params[:circle] if !params[:circle].blank?
            item.Place = params[:place] if !params[:place].blank?
            if params[:itemDescription].blank?
                item.Description = ""
            end
            #list to insert
            list = user.UserWantList.where(_id: params[:listid]).first
            if list != nil
                list.Item << item
                user.save
                status = {"StatusCode" => "OK" , "Status" => "item add OK"}
            else
                status = {"StatusCode" => "UNKNOWN_LIST" , "Status" => "list not found"}
            end
        else
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def EditItem
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:itemid].blank?
            #edit
            item = nil
            user.UserWantList.each do |list|
                itm = list.Item.where(_id: params[:itemid]).first
                if itm != nil
                    item = itm
                    break
                end
            end
            #request
            if item == nil
                status = {"StatusCode" => "ITEM_NOT_FOUND" , "Status" => "item not found"}
            elsif request.post?
                item.Name = params[:name] if !params[:name].blank?
                item.Price = params[:price].to_i if !params[:price].blank?
                item.Description = params[:description] if !params[:description].blank?
                item.save
                status = {"StatusCode" => "OK" , "Status" => "item edit OK"}
            elsif request.delete?
                #item delete
                item.destroy
                status = {"StatusCode" => "OK" , "Status" => "item delete OK"}
            else
                #Unknown
                status = {"StatusCode" => "UNKNOWN_REQUEST" , "Status" => "unknown request??"}
            end
        else
            #Auth error
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def AddComment
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:itemid].blank?
            #edit
            item = nil
            user.UserWantList.each do |list|
                itm = list.Item.where(_id: params[:itemid]).first
                if itm != nil
                    item = itm
                    break
                end
            end
            #request
            if item == nil
                status = {"StatusCode" => "ITEM_NOT_FOUND" , "Status" => "item not found"}
            elsif request.post?
                com = Comment.new
                com.Text = params[:comment]
                com.OwnerUserID = user._id
                item.Comment << com
                item.save
                status = {"StatusCode" => "OK" , "Status" => "item edit OK"}
            else
                #Unknown
                status = {"StatusCode" => "UNKNOWN_REQUEST" , "Status" => "unknown request??"}
            end
        else
            #Auth error
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def EditComment
        user = User.where(UserID: params[:userid]).first
        if user != nil && user.AuthPassword(params[:password]) && !params[:itemid].blank?
            #edit
            com = nil
            begin
                user.UserWantList.each do |list|
                    list.Item.each do |item|
                        com = item.Comment.where(_id: params[:itemid]).first
                        if com != nil
                            raise
                        end
                    end
                end
            rescue
            end
            
            #request
            if com == nil
                status = {"StatusCode" => "ITEM_NOT_FOUND" , "Status" => "item not found"}
            elsif request.post?
                com.Text = params[:text] if !params[:text].blank?
                com.save
                status = {"StatusCode" => "OK" , "Status" => "item edit OK" , "Test" => com}
            elsif request.delete?
                com.destroy
                status = {"StatusCode" => "OK" , "Status" => "item delete OK" }
            else
                #Unknown
                status = {"StatusCode" => "UNKNOWN_REQUEST" , "Status" => "unknown request??"}
            end
        else
            #Auth error
            status = {"StatusCode" => "AUTH_FAILED" , "Status" => "auth failed"}
        end
        respond_to do |format|
            format.json{render:json => status}
        end
    end

    def SearchUser(username)
        user = User.where(UserID: username).first
        logger.debug("username found")
        return user
    end

    def SearchMailAdress(mailadress)
        user = User.where(MailAdress: mailadress).first
        logger.debug("user mail found")
        return user
    end
end
