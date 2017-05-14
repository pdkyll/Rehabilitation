function d = cohen_d(dat1,dat2)
m1 = mean(dat1);
m2 = mean(dat2);

sd1 = std(dat1);
sd2 = std(dat2);
SDpooled = sqrt((sd1.^2 + sd2.^2)/2);

d = (m1-m2)/SDpooled;