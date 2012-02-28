# Lind benchmarking R script
#
#	Stephen Tredger :)
#

#Args <- commandArgs();      # retrieve args
#x <- c(1:as.real(Args[4])); # get the 4th argument

# lind timing files
lind_file_path = "~/Documents/DS/lind_benchmarking/lind_results"
# c timing files
c_file_path = "~/Documents/DS/lind_benchmarking/c_results"
# place to output plots
plot_path = "~/Documents/DS/lind_benchmarking/plots"

# name of file we want to analyze
file_name = "open_read_close"

# plot height and width in # pixels
plot_height = 620
plot_width = 620

pts = c(1:1000)


#
# Gets times by reading in a file, then places the times in a list and returns it
#
get_times_from_file = function(path) {
	data = read.csv(path, header=FALSE, strip.white=TRUE, stringsAsFactors=FALSE)

	start_time = c(do.call("cbind",data[1]))
	finish_time = c(do.call("cbind",data[2]))
	elapsed_time = (finish_time - start_time)
	# standardize time, make it start at t = 0 msec
	std_start_time = start_time - start_time[1]
	
	times = list(start_time=start_time, finish_time=finish_time, 
				elapsed_time=elapsed_time, std_start_time=std_start_time)
}

# read in times for each file
lind_times = get_times_from_file(paste(lind_file_path, file_name, sep="/"))
c_times = get_times_from_file(paste(c_file_path, file_name, sep="/"))

# lind histograms
png(paste(plot_path, "/lind-", file_name, "-hist.png", sep=""), width=plot_width, height=plot_height)
lind_hist = hist(lind_times$elapsed_time, breaks=50, main=paste("Lind", file_name, "histogram"), xlab="elapsed time (sec)")
dev.off()

# c histogram
png(paste(plot_path, "/c-", file_name, "-hist.png", sep=""), width=plot_width, height=plot_height)
c_hist = hist(c_times$elapsed_time, breaks=50, main=paste("Native C", file_name, "histogram"), xlab="elapsed time (sec)")
dev.off()

# colours for scatterplot points
lind_col="red"
c_col="blue"

# lind scatterplot
png(paste(plot_path, "/lind-", file_name, "-scatter.png", sep=""), width=plot_width, height=plot_height)
lind_scplot = plot(lind_times$std_start_time, lind_times$elapsed_time, log="y", pch=20, cex=0.5, xlab="start time (sec)", ylab="log elapsed time log(sec)", main=paste(file_name, "scatterplot"), col=lind_col)
dev.off()


# native c scatterplot
png(paste(plot_path, "/c-", file_name, "-scatter.png", sep=""), width=plot_width, height=plot_height)
c_scplot = plot(c_times$std_start_time, c_times$elapsed_time, log="y", pch=20, cex=0.5, xlab="start time (sec)", ylab="log elapsed time log(sec)", main=paste(file_name, "scatterplot"), col=c_col)
dev.off()


# scatterplot with both c and lind... right now looks like crap as all the c values are crunched together...
png(paste(plot_path, "/both-", file_name, "-scatter.png", sep=""), width=plot_width, height=plot_height)
both_scplot = plot(lind_times$std_start_time, lind_times$elapsed_time, pch=20, cex=0.5, xlab="start time (sec)", ylab="log elapsed time log(sec)", main=paste(file_name, "scatterplot"), col=lind_col)
points(c_times$std_start_time, c_times$elapsed_time, pch=20, cex=0.5, col=c_col)
dev.off()

# Screwing around to get a look at the values on the same plot

# find max value => so get mins maxes and find bounds, then ylim=c(bounds)!!!!!
max_l = max(lind_times$elapsed_time)
max_c = max(c_times$elapsed_time)

# scatterplot with both c and lind but just point # vs elapsed time
png(paste(plot_path, "/both-ptnum-", file_name, "-scatter.png", sep=""), width=plot_width, height=plot_height)
bothpt_scplot = plot(pts, c_times$elapsed_time / max_l, pch=20, cex=0.5, ylim=c(0,1), xlab="trial number", ylab="log elapsed time log(sec)", main=paste(file_name, "scatterplot"), col=c_col)
points(pts, lind_times$elapsed_time / max_l, pch=20, cex=0.5, col=lind_col)
dev.off()

