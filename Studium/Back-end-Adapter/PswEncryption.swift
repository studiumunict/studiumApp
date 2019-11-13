//
//  PswEncryption.swift
//  Studium
//
//  Created by Simone Scionti on 12/08/2019.
//  Copyright © 2019 Unict.it. All rights reserved.
//

import Foundation
class PswEncryption{
    public static func encode(s: String) -> String{
        var resp = "f"
        var i = 0
        var j = s.count-1
        while(i<=j){
            if(i==j){
                let index1 = s.index(s.startIndex, offsetBy: i)
                let c1 = s[index1]
                resp.append(c1)
                resp.append("b")
            }
            else{
                let index1 = s.index(s.startIndex, offsetBy: j)
                let index2 = s.index(s.startIndex, offsetBy: i)
                let c1 = s[index1]
                let c2 = s[index2]
                resp.append(c1)
                resp.append("c")
                resp.append(c2)
                resp.append("z")
            }
            i+=1
            j-=1
        }
        return resp;    }
    
    public static func decode(str : String) -> String{
        var s = "";
        var i = 0
        while(i<str.count){
            if(i%2 != 0){
                let index = str.index(str.startIndex, offsetBy: i)
                s.append(str[index])
            }
            i+=1
        }
        
        var prefix="";
        var suffix="";
        i = 0
        while(i<s.count){
            if(i%2 == 0){
                let index = s.index(s.startIndex, offsetBy: i)
                var stringa = String()
                stringa.append(s[index])
                suffix = stringa+suffix;
            }
            else{
                let index = s.index(s.startIndex, offsetBy: i)
                prefix.append(s[index])
            }
            i+=1
        }
        return prefix+suffix;
    }
}
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
