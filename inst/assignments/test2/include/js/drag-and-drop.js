
// Adapted from https://jsfiddle.net/SupunKavinda/vfxdwtpc/5/

function preventDefault(e) {
	e.preventDefault();
  	e.stopPropagation();
}

function handleDrop(e) {
	var dt = e.originalEvent.dataTransfer,
		files = dt.files;

	if (files.length)
		handleFiles(files);
}

function handleFiles(files) {
	for (var i = 0, len = files.length; i < len; i++) {
		if (validateImage(files[i]))
			previewImage(files[i]);
	}
}

function validateImage(image) {
	// check the type
	var validTypes = ['image/jpeg', 'image/png', 'image/gif'];
	if (validTypes.indexOf( image.type ) === -1) {
		alert("Invalid File Type");
		return false;
	}

	// check the size
	var maxSizeInBytes = 10e6; // 10MB
	if (image.size > maxSizeInBytes) {
		alert("File too large");
		return false;
	}
	return true;
}

function previewImage(image) {

	// container
	var imgView = $("<div></div>")
	  .attr('class', 'image-view')
	  .appendTo("#drop-region-q3 .image-preview")
	  .on('click', function(e){
	    this.remove()
	    e.preventDefault()
	  })

	// previewing image
	var img = $('<img/>')
	  .appendTo(imgView)

	// read the image...
	var reader = new FileReader()
	reader.onload = function(e) {
		img.attr('src', e.target.result)
	}
	reader.readAsDataURL(image);
}
