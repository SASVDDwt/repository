%PREX_EIGENFACES   PRTools example on the use of images and eigenfaces

help prex_eigenfaces

echo on
              % Load one image per each subject (may take a while)
  a = faces([1:40],1);

              % Compute the eigenfaces
  w = pca(a);

              % Display them
  newfig(1,3); show(w); drawnow;

              % Project all faces onto the eigenface space

  b = [];
  for j = 1:40
    a = faces(j,[1:10]);
    b = [b;a*w];
    % Don't echo loops
    echo off
  end
  echo on

              % Show a scatterplot of the first two eigenfaces
  newfig(2,3)
  scatterd(b)
  title('Scatterplot of the first two eigenfaces')

              % Compute leave-one-out error curve
  featsizes = [1 2 3 5 7 10 15 20 30 39];
  e = zeros(1,length(featsizes));
  for j = 1:length(featsizes)
    k = featsizes(j);
     e(j) = testk(b(:,1:k),1);
     echo off
  end
  echo on
              % Plot error curve
  newfig(3,3)
  plot(featsizes,e)
  xlabel('Number of eigenfaces')
  ylabel('Error')
echo off
