# TransitApp

I use Cocoapods as a the third party dependency manager, if you're not familiar with Cocoapoads, here's a link to set it up :

https://guides.cocoapods.org/using/getting-started.html

Once installed:

0. Close the Xcode project if opened 
1. Open a terminal window, and $ cd into your project directory.
2. Create a Podfile. This can be done by running $ pod init.
3. Open the new Podfile (vi Podfile) and add the following dependencies (by pressing i): 

platform :ios, '8.0'
use_frameworks!

pod 'SwiftyJSON'
pod 'GoogleMaps'
pod 'Polyline', '~> 3.0'

4. Press "esq", then ":wq" to write and quite.
5. run pod with command $ pod install.
6. Now, go to the project directory and open App.xcworckspace and build


Comments on Ally,

I didn't implement a coredata model as the data used is static; nevertheless, in a real scenario, persistent storage would be necessary.

I've followed the UI design of the Ally application; Before making my decision, I've compared it to many other Transit Applications out there and it is one of the best. I like the simplicity of the UI and the absence of any confusing elements. The Application is great because it is straightforward and makes no mistake bringing me where I need.

I think it might be interesting to add a comparing UI when all the results are presented in a table. It could be useful to bring out which route is cheaper, which is better for the environment, etc. 

Another aspect interesting to think about would be the social dimension. In the Ally application you can share you trips with friends. What if you were already connected with everybody in your address book that uses Ally, like most messaging Applications. This way, you could potentially know who's near you. Some Applications already do this, but I don't think they achieve true momentum because you wouldn't just use an app to share you geolocation; nevertheless, you might do it if the application hade some real benefits and embeded this new behavior in a modern way of perceiving urban mobility, hence Ally.

I enjoyed very much working on this projecta, and I hope it will spark an interesting conversation between us. 


