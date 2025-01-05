//
//  ContentView.swift
//  SwiftUIAppFirebase
//
//  Created by Hakob Ghlijyan on 12/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Module 01 - Connecting to App Firebase")
            
            Text("Module 02 - Email")
            
            Text("Module 03 - Google ")
            
            Text("Module 04 - Apple")
            
            Text("Module 05 - Anon")
            
            Text("Module 06 - Delete User")
            
            Text("Module 07 - Firebase Firestore - part 1")
            
            Text("Module 07 - Firebase Firestore - part 2")
            
            Text("""
                Module 07 - Firebase Firestore - part 3
                
                End part 3
                1: -add new value in dbuser , and in model movie
                2:- preference array string
                add FieldValue.arrayUnion([preference])
                remove FieldValue.arrayRemove([preference])
                3: - add favorite movie for map datause encoder firebase for make json [String: Any] and for delete

                Profile view add func add and remove
                
                """)
            
            Text("""
                Module 07 - Firebase Firestore - part 4
                
                Part 04 End
                1.
                Add database api call
                add cell product
                ADD PRODUCT view and add iin rootview for testing
                2.
                In Product manager
                add 1 product get by id
                change get all product for custom universal func  getDocumentsT() is
                use history and map all snapshot array
                """)
            
            
            Text("""
                Module 07 - Firebase Firestore - part 5
                           
                Part 05 End
                1. add filter and category option
                filter enum
                sort category enum

                2. add button for order and fileter

                3. Add codding kay for product .. is use in func for sort

                4. Add product manager func for
                get all product .
                get one product
                get all sorted by price
                get all filter category

                add all in one func get all documents 2 func is paramets in use switch for options

                
                """)
            
        }
    }
}

#Preview {
    ContentView()
}
