<a href="https://velog.io/@ximya_hf/optimizing-network-image-rendering-in-flutter"> 한국어 버전 </a>

<br/>
When fetching and displaying network images in Flutter, what important factors should you remember?

In order to provide a better user experience (UX) when using image widgets, you may consider applying a Fade-In animation or displaying a loading indicator before loading images from the network.

While these UX considerations are essential, it’s also crucial to save `memory usage` when rendering `network images`. **This is because larger images require a significant amount of memory during the rendering process.**

To illustrate this, I’d like to share a personal project example. I encountered issues with my app, such as screen stuttering and abnormal crashes. As mentioned earlier, the cause was excessive memory usage when displaying high-resolution network images on the screen.

<p align="center">
    <img src="https://velog.velcdn.com/images/ximya_hf/post/992ace17-07d8-423a-b974-a4caa5da4ec6/image.jpg">
</p>

To avoid making the same mistakes, you need to understand how to optimize rendering when loading images onto the screen. In this post, I’ll introduce ways to effectively render network images while reducing memory usage, so be sure to gather useful tips!


# Diagnosing Oversized Images
First, it's essential to `diagnose` whether **memory usage is excessive** when rendering network images. Let's confirm this through a simple example.

<p align="center">
<img src="https://velog.velcdn.com/images/ximya_hf/post/9043acf9-464d-40a0-9131-b39f7526ed50/image.png">
</p>

```dart
Image.network(
  imageUrl,
  width: 250,
),
``` 

Was the image widget above efficiently rendered? There is a straightforward way to find out.


<p align="center">
    <img src="https://velog.velcdn.com/images/ximya_hf/post/052360f3-d6dd-4471-8349-3348ade94528/image.png">
</p>

Activate the `Highlight oversized images` button in Flutter Inspector.

> **NOTE**
> 
>You can also use the flags provided by Flutter. Add this code to your app's entry point or the class containing the image widget. debugInvertOversizedImages = true;

<p align="center"><img
width = "375"                       src="https://velog.velcdn.com/images/ximya_hf/post/d8270a12-0192-47b7-84b4-601cd46944dc/image.png"/></p>




You will then notice that the image on the screen has been `inverted` in `color and flipped vertically`. This indicates that more memory was used during the image `decoding process` than necessary.

## Display Size & Decode Size

Checking the `error logs` can provide more specific information.

```
Image [...] has a display size of 750×421 but a decode size of 3840×2160,
which uses an additional 41552KB (assuming a device pixel ratio of 3.0).
```

The image on the screen has a size of 750x421, but it has been `decoded` to a size of 3840×2160, using an **additional 41552KB of memory**.

The display size indicates the size at which the image is `decoded`. In other words, when actually displayed on the screen, the necessary display size is only 750×421. **Therefore, decoding the entire original size of the image, 3840×2160 (Decode Size), is unnecessary.**

To make it easier to understand, let’s use an analogy.

<p align="center">
    <img src="https://velog.velcdn.com/images/ximya_hf/post/6de794f1-676a-42d7-9093-a6fe81d7a327/image.png">
</p>

Imagine a scenario where you ask an artist to paint a picture based on a photo you took with a friend. When providing the photo to the artist, there’s no need to give them a much `larger billboard-sized photo` than what’s required to create the painting. **In fact, such a large photo can hinder the artist’s work.**

<p align="center">
    <img src="https://velog.velcdn.com/images/ximya_hf/post/330069f3-39f3-4f78-a0c2-61ea979b63d0/image.png">
</p>


To paint a precise and fast picture, the artist only needs a photo of the appropriate size. **This concept applies when loading network images in Flutter**. If the image’s size is much larger than the size it will be displayed on the screen (Display Size), the Flutter engine wastes memory during the decoding process.


> **Artist**: Flutter Engine 
> 
> **Photo** provided to the artist: Display Size
> 
> **Artist’s act of painting**: Decoding
> 
> **The painting created by the artist**: Image Widget

## Resizing Images
So, how should you `adjust the size` of images to decode? The following error log provides guidance on how to resize images.

```
Consider resizing the asset ahead of time,
supplying a cacheWidth parameter of 750, a cacheHeight parameter of 421, or using a ResizeImage
```

The method for resizing images is to use the `cacheWidth` and `cacheHeight` properties of Image.network. These properties allow you to adjust the image to the desired size before decoding. Regardless of the actual display size of the image, it will be decoded to the size specified in these properties. Setting these properties is crucial because all network images are `cached` in Image.network regardless of HTTP headers.

> **NOTE**
> 
> The size of the image displayed on the screen is determined by the ‘width’ and ‘height’ properties, but the size of the rendered image is determined by ‘cacheWidth’ and ‘cacheHeight’. 


Now, let’s make code modifications based on the log.

```dart
Image.network(
  imageUrl,
  width: 250,
  cacheWidth: 750,
),
const Divider(),
Image.network(
  imageUrl,
  width: 250,
),
```

For comparison, I’ve added a widget without the `cacheWidth` property set. (If you set one cache property, the other will resize the image while maintaining its aspect ratio)

<p align="center"><img
width = "375" src="https://velog.velcdn.com/images/ximya_hf/post/7af9a26a-e7b3-4190-8a3f-6f9604b8df64/image.png"/></p>


The image with cacheWidth set is displayed without any `oversized errors`, while the other image has its colors and orientation inverted and flipped vertically. **By correctly setting cacheWidth, we have optimized memory usage in the decoding process by resizing the image.**

## Device-Specific Pixel Ratios

However, issues may still arise.

<p align="center"><img
src="https://velog.velcdn.com/images/ximya_hf/post/10e92806-1aed-44c6-a8fa-e5f57e7f4993/image.png"/></p>

In the same code with `cacheWidth` set, the image displays correctly on the iPhone 12 mini, but on the smaller-screen iPhone SE, it still indicates an `oversize`.

Why does this problem occur? Let’s check the error logs again.

#### iPhone 12 mini
```
Image [...] has a display size of 750×421 but a decode size of 3840×2160, which uses an additional 41552KB (assuming a device pixel ratio of 3.0).
Consider resizing the asset ahead of time, supplying a cacheWidth parameter of 750, a cacheHeight parameter of 421, or using a ResizeImage.
```
In the case of the iPhone 12 mini, the image has a display width of 750, and the device pixel ratio is 3.0.


#### iPhone SE
```
Image [...] has a display size of 500×281 but a decode size of 3840×2160, which uses an additional 42467KB (assuming a device pixel ratio of 2.0).
Consider resizing the asset ahead of time, supplying a cacheWidth parameter of 500, a cacheHeight parameter of 281, or using a ResizeImage.
```

On the other hand, for the iPhone SE, the image’s display size is 500, and the device pixel ratio is 2.0.

**This difference occurs because of the varying `device pixel ratios` of each device.**

The `device pixel ratio` represents the `density of pixels` displayed on a device's screen, indicating how many pixels are displayed per unit of screen size on a specific device.

<p align="center">
    <img src="https://velog.velcdn.com/images/ximya_hf/post/effd2696-22a3-4338-9e3f-ed46f455e2b8/image.png">
</p>


Pixel density is typically measured in `ppi (pixels per inch)` and can have various values depending on the screen size of a specific device. For instance, high-resolution devices contain more pixels per unit of screen size, resulting in a higher pixel density.

In summary, the iPhone SE has a `pixel ratio` of 2.0, which means that 2 pixels are displayed per inch, while the iPhone 12 mini has 3 pixels displayed per inch. Therefore, **when setting cacheWidth based on the iPhone 12 mini, there is still unnecessary decoding size left on the iPhone SE due to its lower pixel ratio.**

## Dynamically Determining Image Cache Size

Now that we have all the clues, we can calculate the `cacheWidth` value based on the device's `pixel ratio`.

```
250 (widget size) X 2 (iPhone SE device pixel ratio) = 500 (cache size)
```

With a target widget size of 250 and an iPhone SE displaying 2 pixels per inch, multiplying the widget size by the device pixel ratio gives us the appropriate display size (500).

Here’s the code representation.

```dart
Image.network(  
  imageUrl,  
  width: 250,  
  cacheWidth: (250 * MediaQuery.of(context).devicePixelRatio).round(),  
)
```

Using `MediaQuery`, we determine the device's pixel ratio and set the cacheWidth value by multiplying it with the image widget's width. Since the cacheWidth property requires an integer value, we use the round method to round it to the nearest integer. With this code, **you can resize the image according to the device's pixel ratio.**

Additionally, to make the code more concise, you can implement the image size calculation as an `extension`. Here is an example of the code with the extension.

```dart
extension ImageExtension on num {  
  int cacheSize(BuildContext context) {  
    return (this * MediaQuery.of(context).devicePixelRatio).round();  
  }  
}
```

Then, you can use the `extension` in the image widget to set the necessary cache value concisely .

```dart
Image.network(  
  imageUrl,  
  width: 250,  
  cacheWidth: 250.cacheSize(context),  
)
```

## Considerations When Specifying Cache Size

If the original image’s aspect ratio is different from the target widget’s aspect ratio, and the image widget has `fit: BoxFit.cover`, you need to consider `certain aspects` when setting the cache size. Typically, when using `fit: BoxFit.cover`, the image is cropped to fit the widget. In such cases, you should consider the aspect ratio when determining the image's display size.

**If the original image and the widget have different aspect ratios, you should set the cache size based on the `smaller dimension` (width or height) to maintain the aspect ratio of the original image while optimizing the image.**

Setting it the other way around can result in displaying a `lower resolution image`.

Let’s look at an example.

```dart
Image.network(  
  imageUrl,  
  width: 250,  
  height: 250,  
  cacheWidth: 250.cacheSize(context),  
  fit: BoxFit.cover,
)
```
 <p align="center"><img
src="https://velog.velcdn.com/images/ximya_hf/post/f2669148-d373-465b-87b2-da63b5d695ce/image.png"/></p>

- Image size: 3000 x 1688
- Image aspect ratio: 1.7
- Decoded image’s display size: 500 x 282
- Image widget size: 250 x 250
- Image widget aspect ratio: 1

Setting cacheWidth to 500 (widget width x device pixel ratio) for image widgets with dimensions of 250 x 250 will automatically determine the display height while maintaining the aspect ratio of the image. However, the original image has a ratio where the width is greater than the height, which is different from the aspect ratio required for the widget to be displayed. As a result, the display height of the decoded image (281) will be lower than the target display height (500), making the image appear `blurry`, as shown in the example picture.

On the other hand, when you set cacheHeight.

```dart
Image.network(  
  imageUrl,  
  width: 250,  
  height: 250,  
  cacheHeight: 250.cacheSize(context),  
  fit: BoxFit.cover,
)
```

 <p align="center"><img
src="https://velog.velcdn.com/images/ximya_hf/post/4819233d-570c-41a5-8635-bf457ab9d97c/image.png"/></p>

Setting cacheHeight `maintains the aspect ratio` of the image while `resizing` it to the `minimum display size`, preserving the image's sharp resolution.

The oversized error log still occurs, but the image has been optimized by significantly reducing the size of the image to be decoded and maintaining the aspect ratio, providing a clear image.

## Dynamically Specifying Cache Size Considering Image Aspect Ratio

However, in most cases, frontend developer don’t know the aspect ratio of network images in advance. In such situations, you can dynamically determine the cache size based on whether the original image’s `aspect ratio is greater than 0` or not.

```dart
Builder(  
   builder: (context) {  
   int? cacheWidth, cacheHeight;  
   Size targetSize = const Size(250, 250);  
   const double originImgAspectRatio = 1.7;

    // If the original image aspect ratio is greater than 0, it means the image is wider than it is tall.
    if (originImgAspectRatio > 0) {  
      cacheHeight = targetSize.height.cacheSize(context);  
    } else {  
      cacheWidth = targetSize.width.cacheSize(context);  
    }  
  
    return Image.network(  
      imageUrl,  
      width: targetSize.width,  
      height: targetSize.height,  
      cacheWidth: cacheWidth,  
      cacheHeight: cacheHeight,  
      fit: BoxFit.cover,  
    );  
  },  
)
```
**In the above code, we use the aspect ratio of the original image (originImgAspectRatio) to conditionally determine whether to set cacheWidth or cacheHeight as the cache size.** As mentioned earlier, if you set only one of the cache size properties, the image will be resized according to the aspect ratio, so it's perfectly fine to set the other property to null.

> **What if I don’t know the aspect ratio or size of the original image? 🤔**
>
>Flutter provides methods to determine the size or aspect ratio of an original image, but it’s not recommended due to potential delays in asynchronous operations.
The best practice is to receive both the image URL and its size (or aspect ratio) from the server when fetching network image resources. Many open APIs like YouTube and TMDb provide image URLs along with size or aspect ratio information for efficient use in your app.

## CacheNetworkImage Package
While Flutter provides the `Image.network` widget for loading images from the network, it is recommended to use the `cached_network_image` package for image caching. This package offers fine-grained control over caching, which can help enhance performance. Here's an example of using the cached_network_image package.

```dart
CachedNetworkImage(   
  imageUrl: imageUrl,  
  memCacheHeight: 320.cacheSize(context),  
  memCacheWidth: 250.cacheSize(context),  
)
```
With the CachedNetworkImage widget, you can use the memCacheHeight and memCacheWidth properties to specify the cache size, similar to the Image.network widget.

