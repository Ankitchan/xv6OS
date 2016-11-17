
_hackbench:     file format elf32-i386


Disassembly of section .text:

00000000 <rdtsc>:
{
  asm volatile("hlt");
}

static inline unsigned long long rdtsc(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
    unsigned long long ret;
    asm volatile ( "rdtsc" : "=A"(ret) );
   6:	0f 31                	rdtsc  
   8:	89 45 f8             	mov    %eax,-0x8(%ebp)
   b:	89 55 fc             	mov    %edx,-0x4(%ebp)
    return ret;
   e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  11:	8b 55 fc             	mov    -0x4(%ebp),%edx
}
  14:	c9                   	leave  
  15:	c3                   	ret    

00000016 <barf>:
}pollfd[512];



static void barf(const char *msg)
{
  16:	55                   	push   %ebp
  17:	89 e5                	mov    %esp,%ebp
  19:	83 ec 08             	sub    $0x8,%esp
  printf(STDOUT, "(Error: %s)\n", msg);
  1c:	83 ec 04             	sub    $0x4,%esp
  1f:	ff 75 08             	pushl  0x8(%ebp)
  22:	68 60 0e 00 00       	push   $0xe60
  27:	6a 01                	push   $0x1
  29:	e8 4d 0a 00 00       	call   a7b <printf>
  2e:	83 c4 10             	add    $0x10,%esp
  exit();
  31:	e8 6a 08 00 00       	call   8a0 <exit>

00000036 <fdpair>:
}

static void fdpair(int fds[2])
{
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	83 ec 08             	sub    $0x8,%esp
  if (use_pipes) {
  3c:	a1 68 13 00 00       	mov    0x1368,%eax
  41:	85 c0                	test   %eax,%eax
  43:	74 21                	je     66 <fdpair+0x30>
    // TODO: Implement myPipe
    //    pipe(fds[0], fds[1]);
    if (pipe(fds) == 0)
  45:	83 ec 0c             	sub    $0xc,%esp
  48:	ff 75 08             	pushl  0x8(%ebp)
  4b:	e8 60 08 00 00       	call   8b0 <pipe>
  50:	83 c4 10             	add    $0x10,%esp
  53:	85 c0                	test   %eax,%eax
  55:	75 21                	jne    78 <fdpair+0x42>
      fd_count += 2;
  57:	a1 80 13 00 00       	mov    0x1380,%eax
  5c:	83 c0 02             	add    $0x2,%eax
  5f:	a3 80 13 00 00       	mov    %eax,0x1380
    return;
  64:	eb 12                	jmp    78 <fdpair+0x42>
  } else {
    // This mode would not run correctly in xv6
    //if (socketpair(AF_UNIX, SOCK_STREAM, 0, fds) == 0)
    //  return;
    barf("Socket mode is running. (error)\n");
  66:	83 ec 0c             	sub    $0xc,%esp
  69:	68 70 0e 00 00       	push   $0xe70
  6e:	e8 a3 ff ff ff       	call   16 <barf>
  73:	83 c4 10             	add    $0x10,%esp
  76:	eb 01                	jmp    79 <fdpair+0x43>
    return;
  78:	90                   	nop
  }
  //barf("Creating fdpair");
}
  79:	c9                   	leave  
  7a:	c3                   	ret    

0000007b <checkEvents>:

static void checkEvents(int id, int event, int caller, char *msg){
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	83 ec 08             	sub    $0x8,%esp
  if(event == POLLIN){
  81:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  85:	75 5e                	jne    e5 <checkEvents+0x6a>
    if(caller == SENDER){
  87:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8b:	75 20                	jne    ad <checkEvents+0x32>
      printf(STDOUT, "send[%d] is %s ... (pollfd[%d].events = POLLIN)\n", id, msg, id);
  8d:	83 ec 0c             	sub    $0xc,%esp
  90:	ff 75 08             	pushl  0x8(%ebp)
  93:	ff 75 14             	pushl  0x14(%ebp)
  96:	ff 75 08             	pushl  0x8(%ebp)
  99:	68 94 0e 00 00       	push   $0xe94
  9e:	6a 01                	push   $0x1
  a0:	e8 d6 09 00 00       	call   a7b <printf>
  a5:	83 c4 20             	add    $0x20,%esp
      barf("checkEvents");
    }
  }else{
    barf("checkEvents");
  }	      
}
  a8:	e9 a6 00 00 00       	jmp    153 <checkEvents+0xd8>
    }else if(caller == RECEIVER){
  ad:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
  b1:	75 20                	jne    d3 <checkEvents+0x58>
      printf(STDOUT, "recv[%d] is %s ... (pollfd[%d].events = POLLIN)\n", id, msg, id);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	ff 75 08             	pushl  0x8(%ebp)
  b9:	ff 75 14             	pushl  0x14(%ebp)
  bc:	ff 75 08             	pushl  0x8(%ebp)
  bf:	68 c8 0e 00 00       	push   $0xec8
  c4:	6a 01                	push   $0x1
  c6:	e8 b0 09 00 00       	call   a7b <printf>
  cb:	83 c4 20             	add    $0x20,%esp
}
  ce:	e9 80 00 00 00       	jmp    153 <checkEvents+0xd8>
      barf("checkEvents");
  d3:	83 ec 0c             	sub    $0xc,%esp
  d6:	68 f9 0e 00 00       	push   $0xef9
  db:	e8 36 ff ff ff       	call   16 <barf>
  e0:	83 c4 10             	add    $0x10,%esp
}
  e3:	eb 6e                	jmp    153 <checkEvents+0xd8>
  }else if(event == FREE){
  e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  e9:	75 58                	jne    143 <checkEvents+0xc8>
    if(caller == SENDER){
  eb:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  ef:	75 1d                	jne    10e <checkEvents+0x93>
      printf(STDOUT, "send[%d] is %s ... (pollfd[%d].events = FREE)\n", id, msg, id);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 08             	pushl  0x8(%ebp)
  f7:	ff 75 14             	pushl  0x14(%ebp)
  fa:	ff 75 08             	pushl  0x8(%ebp)
  fd:	68 08 0f 00 00       	push   $0xf08
 102:	6a 01                	push   $0x1
 104:	e8 72 09 00 00       	call   a7b <printf>
 109:	83 c4 20             	add    $0x20,%esp
}
 10c:	eb 45                	jmp    153 <checkEvents+0xd8>
    }else if(caller == RECEIVER){
 10e:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
 112:	75 1d                	jne    131 <checkEvents+0xb6>
      printf(STDOUT, "recv[%d] is %s ... (pollfd[%d].events = FREE)\n", id, msg, id);
 114:	83 ec 0c             	sub    $0xc,%esp
 117:	ff 75 08             	pushl  0x8(%ebp)
 11a:	ff 75 14             	pushl  0x14(%ebp)
 11d:	ff 75 08             	pushl  0x8(%ebp)
 120:	68 38 0f 00 00       	push   $0xf38
 125:	6a 01                	push   $0x1
 127:	e8 4f 09 00 00       	call   a7b <printf>
 12c:	83 c4 20             	add    $0x20,%esp
}
 12f:	eb 22                	jmp    153 <checkEvents+0xd8>
      barf("checkEvents");
 131:	83 ec 0c             	sub    $0xc,%esp
 134:	68 f9 0e 00 00       	push   $0xef9
 139:	e8 d8 fe ff ff       	call   16 <barf>
 13e:	83 c4 10             	add    $0x10,%esp
}
 141:	eb 10                	jmp    153 <checkEvents+0xd8>
    barf("checkEvents");
 143:	83 ec 0c             	sub    $0xc,%esp
 146:	68 f9 0e 00 00       	push   $0xef9
 14b:	e8 c6 fe ff ff       	call   16 <barf>
 150:	83 c4 10             	add    $0x10,%esp
}
 153:	90                   	nop
 154:	c9                   	leave  
 155:	c3                   	ret    

00000156 <ready>:

/* Block until we're ready to go */
static void ready(int ready_out, int wakefd, int id, int caller)
{
 156:	55                   	push   %ebp
 157:	89 e5                	mov    %esp,%ebp
 159:	83 ec 18             	sub    $0x18,%esp
  char dummy;
  dummy = 'a';
 15c:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  // TODO: Implement myPoll function
  pollfd[id].fd = wakefd;
 160:	8b 45 10             	mov    0x10(%ebp),%eax
 163:	8b 55 0c             	mov    0xc(%ebp),%edx
 166:	89 14 c5 a0 13 00 00 	mov    %edx,0x13a0(,%eax,8)
  if(caller == RECEIVER) pollfd[id].events = POLLIN;
 16d:	83 7d 14 02          	cmpl   $0x2,0x14(%ebp)
 171:	75 0d                	jne    180 <ready+0x2a>
 173:	8b 45 10             	mov    0x10(%ebp),%eax
 176:	66 c7 04 c5 a4 13 00 	movw   $0x1,0x13a4(,%eax,8)
 17d:	00 01 00 

  /* Tell them we're ready. */
  if (write(ready_out, &dummy, 1) != 1)
 180:	83 ec 04             	sub    $0x4,%esp
 183:	6a 01                	push   $0x1
 185:	8d 45 f7             	lea    -0x9(%ebp),%eax
 188:	50                   	push   %eax
 189:	ff 75 08             	pushl  0x8(%ebp)
 18c:	e8 2f 07 00 00       	call   8c0 <write>
 191:	83 c4 10             	add    $0x10,%esp
 194:	83 f8 01             	cmp    $0x1,%eax
 197:	74 10                	je     1a9 <ready+0x53>
    barf("CLIENT: ready write");
 199:	83 ec 0c             	sub    $0xc,%esp
 19c:	68 67 0f 00 00       	push   $0xf67
 1a1:	e8 70 fe ff ff       	call   16 <barf>
 1a6:	83 c4 10             	add    $0x10,%esp

  /* Wait for "GO" signal */
  //TODO: Polling should be re-implemented for xv6.
  //if (poll(&pollfd, 1, -1) != 1)
  //        barf("poll");
  if(caller == SENDER){
 1a9:	83 7d 14 01          	cmpl   $0x1,0x14(%ebp)
 1ad:	75 14                	jne    1c3 <ready+0x6d>
    if(DEBUG) checkEvents(id, pollfd[id].events, caller, "waiting");
    while(pollfd[id].events == POLLIN);
 1af:	90                   	nop
 1b0:	8b 45 10             	mov    0x10(%ebp),%eax
 1b3:	0f b7 04 c5 a4 13 00 	movzwl 0x13a4(,%eax,8),%eax
 1ba:	00 
 1bb:	66 83 f8 01          	cmp    $0x1,%ax
 1bf:	74 ef                	je     1b0 <ready+0x5a>
    //while(getticks() < TIMEOUT);
    if(DEBUG) checkEvents(id, pollfd[id].events, caller, "ready");
  }else{
    barf("Failed being ready.");
  }
}
 1c1:	eb 25                	jmp    1e8 <ready+0x92>
  }else if(caller == RECEIVER){
 1c3:	83 7d 14 02          	cmpl   $0x2,0x14(%ebp)
 1c7:	75 0f                	jne    1d8 <ready+0x82>
    pollfd[id].events = FREE;
 1c9:	8b 45 10             	mov    0x10(%ebp),%eax
 1cc:	66 c7 04 c5 a4 13 00 	movw   $0x0,0x13a4(,%eax,8)
 1d3:	00 00 00 
}
 1d6:	eb 10                	jmp    1e8 <ready+0x92>
    barf("Failed being ready.");
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	68 7b 0f 00 00       	push   $0xf7b
 1e0:	e8 31 fe ff ff       	call   16 <barf>
 1e5:	83 c4 10             	add    $0x10,%esp
}
 1e8:	90                   	nop
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <sender>:
static void sender(unsigned int num_fds,
                   unsigned int out_fd[num_fds],
                   int ready_out,
                   int wakefd,
		   int id)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	53                   	push   %ebx
 1ef:	81 ec 84 00 00 00    	sub    $0x84,%esp
  char data[DATASIZE];
  int k;
  for(k=0; k<DATASIZE-1 ; k++){
 1f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1fc:	eb 0f                	jmp    20d <sender+0x22>
    data[k] = 'b';
 1fe:	8d 55 80             	lea    -0x80(%ebp),%edx
 201:	8b 45 f4             	mov    -0xc(%ebp),%eax
 204:	01 d0                	add    %edx,%eax
 206:	c6 00 62             	movb   $0x62,(%eax)
  for(k=0; k<DATASIZE-1 ; k++){
 209:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 20d:	83 7d f4 62          	cmpl   $0x62,-0xc(%ebp)
 211:	7e eb                	jle    1fe <sender+0x13>
  }
  data[k] = '\0';
 213:	8d 55 80             	lea    -0x80(%ebp),%edx
 216:	8b 45 f4             	mov    -0xc(%ebp),%eax
 219:	01 d0                	add    %edx,%eax
 21b:	c6 00 00             	movb   $0x0,(%eax)
  
  unsigned int i, j;

  //TODO: Fix Me?
  ready(ready_out, wakefd, id, SENDER);
 21e:	6a 01                	push   $0x1
 220:	ff 75 18             	pushl  0x18(%ebp)
 223:	ff 75 14             	pushl  0x14(%ebp)
 226:	ff 75 10             	pushl  0x10(%ebp)
 229:	e8 28 ff ff ff       	call   156 <ready>
 22e:	83 c4 10             	add    $0x10,%esp

  /* Now pump to every receiver. */
  for (i = 0; i < loops; i++) {
 231:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 238:	eb 7e                	jmp    2b8 <sender+0xcd>
    for (j = 0; j < num_fds; j++) {
 23a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 241:	eb 69                	jmp    2ac <sender+0xc1>
      int ret, done = 0;
 243:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    again:
      ret = write(out_fd[j], data + done, sizeof(data)-done);
 24a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 24d:	ba 64 00 00 00       	mov    $0x64,%edx
 252:	29 c2                	sub    %eax,%edx
 254:	89 d0                	mov    %edx,%eax
 256:	89 c3                	mov    %eax,%ebx
 258:	8b 45 e8             	mov    -0x18(%ebp),%eax
 25b:	8d 55 80             	lea    -0x80(%ebp),%edx
 25e:	01 d0                	add    %edx,%eax
 260:	8b 55 ec             	mov    -0x14(%ebp),%edx
 263:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
 26a:	8b 55 0c             	mov    0xc(%ebp),%edx
 26d:	01 ca                	add    %ecx,%edx
 26f:	8b 12                	mov    (%edx),%edx
 271:	83 ec 04             	sub    $0x4,%esp
 274:	53                   	push   %ebx
 275:	50                   	push   %eax
 276:	52                   	push   %edx
 277:	e8 44 06 00 00       	call   8c0 <write>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(DEBUG) printf(STDOUT, "send[%d]: ret = %d. (%d/%d/%d)\n", id, ret, i, num_fds, loops);
      if (ret < 0)
 282:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 286:	79 10                	jns    298 <sender+0xad>
	barf("SENDER: write");
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	68 8f 0f 00 00       	push   $0xf8f
 290:	e8 81 fd ff ff       	call   16 <barf>
 295:	83 c4 10             	add    $0x10,%esp
      done += ret;
 298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 29b:	01 45 e8             	add    %eax,-0x18(%ebp)
      if (done < sizeof(data))
 29e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2a1:	83 f8 63             	cmp    $0x63,%eax
 2a4:	77 02                	ja     2a8 <sender+0xbd>
	goto again;
 2a6:	eb a2                	jmp    24a <sender+0x5f>
    for (j = 0; j < num_fds; j++) {
 2a8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 2ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2af:	3b 45 08             	cmp    0x8(%ebp),%eax
 2b2:	72 8f                	jb     243 <sender+0x58>
  for (i = 0; i < loops; i++) {
 2b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 2b8:	a1 64 13 00 00       	mov    0x1364,%eax
 2bd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
 2c0:	0f 82 74 ff ff ff    	jb     23a <sender+0x4f>
      if(DEBUG) printf(STDOUT, "send[%d]'s task has done. (%d/%d/%d)\n", id, ret, i, num_fds, loops);
    }
  }
}
 2c6:	90                   	nop
 2c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <receiver>:
static void receiver(unsigned int num_packets,
                     int in_fd,
                     int ready_out,
                     int wakefd,
		     int id)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 78             	sub    $0x78,%esp
  unsigned int i;

  /* Wait for start... */
  ready(ready_out, wakefd, id, RECEIVER);
 2d2:	6a 02                	push   $0x2
 2d4:	ff 75 18             	pushl  0x18(%ebp)
 2d7:	ff 75 14             	pushl  0x14(%ebp)
 2da:	ff 75 10             	pushl  0x10(%ebp)
 2dd:	e8 74 fe ff ff       	call   156 <ready>
 2e2:	83 c4 10             	add    $0x10,%esp

  /* Receive them all */
  for (i = 0; i < num_packets; i++) {
 2e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2ec:	eb 52                	jmp    340 <receiver+0x74>
    char data[DATASIZE];
    int ret, done = 0;
 2ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  again:
    ret = read(in_fd, data + done, DATASIZE - done);
 2f5:	b8 64 00 00 00       	mov    $0x64,%eax
 2fa:	2b 45 f0             	sub    -0x10(%ebp),%eax
 2fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
 300:	8d 4d 88             	lea    -0x78(%ebp),%ecx
 303:	01 ca                	add    %ecx,%edx
 305:	83 ec 04             	sub    $0x4,%esp
 308:	50                   	push   %eax
 309:	52                   	push   %edx
 30a:	ff 75 0c             	pushl  0xc(%ebp)
 30d:	e8 a6 05 00 00       	call   8b8 <read>
 312:	83 c4 10             	add    $0x10,%esp
 315:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(DEBUG) printf(STDOUT, "recv[%d]: ret = %d. (%d/%d)\n", id, ret, i, num_packets);
    if (ret < 0)
 318:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 31c:	79 10                	jns    32e <receiver+0x62>
      barf("SERVER: read");
 31e:	83 ec 0c             	sub    $0xc,%esp
 321:	68 9d 0f 00 00       	push   $0xf9d
 326:	e8 eb fc ff ff       	call   16 <barf>
 32b:	83 c4 10             	add    $0x10,%esp
    done += ret;
 32e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 331:	01 45 f0             	add    %eax,-0x10(%ebp)
    if (done < DATASIZE){
 334:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 338:	7f 02                	jg     33c <receiver+0x70>
      goto again;
 33a:	eb b9                	jmp    2f5 <receiver+0x29>
  for (i = 0; i < num_packets; i++) {
 33c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 340:	8b 45 f4             	mov    -0xc(%ebp),%eax
 343:	3b 45 08             	cmp    0x8(%ebp),%eax
 346:	72 a6                	jb     2ee <receiver+0x22>
    }
    if(DEBUG) printf(STDOUT, "recv[%d]'s task has done. (%d/%d)\n", id, i, num_packets);
  }
}
 348:	90                   	nop
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <group>:

/* One group of senders and receivers */
static unsigned int group(unsigned int num_fds,
                          int ready_out,
                          int wakefd)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	53                   	push   %ebx
 34f:	83 ec 24             	sub    $0x24,%esp
 352:	89 e0                	mov    %esp,%eax
 354:	89 c3                	mov    %eax,%ebx
  unsigned int i;
  unsigned int out_fds[num_fds];
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	89 c2                	mov    %eax,%edx
 35b:	83 ea 01             	sub    $0x1,%edx
 35e:	89 55 f0             	mov    %edx,-0x10(%ebp)
 361:	c1 e0 02             	shl    $0x2,%eax
 364:	8d 50 03             	lea    0x3(%eax),%edx
 367:	b8 10 00 00 00       	mov    $0x10,%eax
 36c:	83 e8 01             	sub    $0x1,%eax
 36f:	01 d0                	add    %edx,%eax
 371:	b9 10 00 00 00       	mov    $0x10,%ecx
 376:	ba 00 00 00 00       	mov    $0x0,%edx
 37b:	f7 f1                	div    %ecx
 37d:	6b c0 10             	imul   $0x10,%eax,%eax
 380:	29 c4                	sub    %eax,%esp
 382:	89 e0                	mov    %esp,%eax
 384:	83 c0 03             	add    $0x3,%eax
 387:	c1 e8 02             	shr    $0x2,%eax
 38a:	c1 e0 02             	shl    $0x2,%eax
 38d:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i = 0; i < num_fds; i++) {
 390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 397:	e9 94 00 00 00       	jmp    430 <group+0xe5>
    int fds[2];

    /* Create the pipe between client and server */
    fdpair(fds);
 39c:	83 ec 0c             	sub    $0xc,%esp
 39f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 3a2:	50                   	push   %eax
 3a3:	e8 8e fc ff ff       	call   36 <fdpair>
 3a8:	83 c4 10             	add    $0x10,%esp

    /* Fork the receiver. */
    switch (fork()) {
 3ab:	e8 e8 04 00 00       	call   898 <fork>
 3b0:	83 f8 ff             	cmp    $0xffffffff,%eax
 3b3:	74 06                	je     3bb <group+0x70>
 3b5:	85 c0                	test   %eax,%eax
 3b7:	74 12                	je     3cb <group+0x80>
 3b9:	eb 54                	jmp    40f <group+0xc4>
    case -1: barf("fork()");
 3bb:	83 ec 0c             	sub    $0xc,%esp
 3be:	68 aa 0f 00 00       	push   $0xfaa
 3c3:	e8 4e fc ff ff       	call   16 <barf>
 3c8:	83 c4 10             	add    $0x10,%esp
    case 0:
      close(fds[1]);
 3cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 3ce:	83 ec 0c             	sub    $0xc,%esp
 3d1:	50                   	push   %eax
 3d2:	e8 f1 04 00 00       	call   8c8 <close>
 3d7:	83 c4 10             	add    $0x10,%esp
      fd_count++;
 3da:	a1 80 13 00 00       	mov    0x1380,%eax
 3df:	83 c0 01             	add    $0x1,%eax
 3e2:	a3 80 13 00 00       	mov    %eax,0x1380
      receiver(num_fds*loops, fds[0], ready_out, wakefd, i);
 3e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3ed:	a1 64 13 00 00       	mov    0x1364,%eax
 3f2:	0f af 45 08          	imul   0x8(%ebp),%eax
 3f6:	83 ec 0c             	sub    $0xc,%esp
 3f9:	51                   	push   %ecx
 3fa:	ff 75 10             	pushl  0x10(%ebp)
 3fd:	ff 75 0c             	pushl  0xc(%ebp)
 400:	52                   	push   %edx
 401:	50                   	push   %eax
 402:	e8 c5 fe ff ff       	call   2cc <receiver>
 407:	83 c4 20             	add    $0x20,%esp
      exit();
 40a:	e8 91 04 00 00       	call   8a0 <exit>
    }

    out_fds[i] = fds[1];
 40f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 412:	89 c1                	mov    %eax,%ecx
 414:	8b 45 ec             	mov    -0x14(%ebp),%eax
 417:	8b 55 f4             	mov    -0xc(%ebp),%edx
 41a:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
    close(fds[0]);
 41d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 420:	83 ec 0c             	sub    $0xc,%esp
 423:	50                   	push   %eax
 424:	e8 9f 04 00 00       	call   8c8 <close>
 429:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < num_fds; i++) {
 42c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	3b 45 08             	cmp    0x8(%ebp),%eax
 436:	0f 82 60 ff ff ff    	jb     39c <group+0x51>
  }

  /* Now we have all the fds, fork the senders */
  for (i = 0; i < num_fds; i++) {
 43c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 443:	eb 52                	jmp    497 <group+0x14c>
    switch (fork()) {
 445:	e8 4e 04 00 00       	call   898 <fork>
 44a:	83 f8 ff             	cmp    $0xffffffff,%eax
 44d:	74 06                	je     455 <group+0x10a>
 44f:	85 c0                	test   %eax,%eax
 451:	74 12                	je     465 <group+0x11a>
 453:	eb 3e                	jmp    493 <group+0x148>
    case -1: barf("fork()");
 455:	83 ec 0c             	sub    $0xc,%esp
 458:	68 aa 0f 00 00       	push   $0xfaa
 45d:	e8 b4 fb ff ff       	call   16 <barf>
 462:	83 c4 10             	add    $0x10,%esp
    case 0:
      fd_count += 2;
 465:	a1 80 13 00 00       	mov    0x1380,%eax
 46a:	83 c0 02             	add    $0x2,%eax
 46d:	a3 80 13 00 00       	mov    %eax,0x1380
      sender(num_fds, out_fds, ready_out, wakefd, i);
 472:	8b 55 f4             	mov    -0xc(%ebp),%edx
 475:	8b 45 ec             	mov    -0x14(%ebp),%eax
 478:	83 ec 0c             	sub    $0xc,%esp
 47b:	52                   	push   %edx
 47c:	ff 75 10             	pushl  0x10(%ebp)
 47f:	ff 75 0c             	pushl  0xc(%ebp)
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 60 fd ff ff       	call   1eb <sender>
 48b:	83 c4 20             	add    $0x20,%esp
      exit();
 48e:	e8 0d 04 00 00       	call   8a0 <exit>
  for (i = 0; i < num_fds; i++) {
 493:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 497:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49a:	3b 45 08             	cmp    0x8(%ebp),%eax
 49d:	72 a6                	jb     445 <group+0xfa>
    }
  }

  /* Close the fds we have left */
  for (i = 0; i < num_fds; i++)
 49f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4a6:	eb 19                	jmp    4c1 <group+0x176>
    close(out_fds[i]);
 4a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ae:	8b 04 90             	mov    (%eax,%edx,4),%eax
 4b1:	83 ec 0c             	sub    $0xc,%esp
 4b4:	50                   	push   %eax
 4b5:	e8 0e 04 00 00       	call   8c8 <close>
 4ba:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < num_fds; i++)
 4bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c4:	3b 45 08             	cmp    0x8(%ebp),%eax
 4c7:	72 df                	jb     4a8 <group+0x15d>

  /* Reap number of children to reap */
  return num_fds * 2;
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	01 c0                	add    %eax,%eax
 4ce:	89 dc                	mov    %ebx,%esp
}
 4d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <main>:

int main(int argc, char *argv[])
{
 4d5:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 4d9:	83 e4 f0             	and    $0xfffffff0,%esp
 4dc:	ff 71 fc             	pushl  -0x4(%ecx)
 4df:	55                   	push   %ebp
 4e0:	89 e5                	mov    %esp,%ebp
 4e2:	51                   	push   %ecx
 4e3:	83 ec 44             	sub    $0x44,%esp
 4e6:	89 c8                	mov    %ecx,%eax
  unsigned int i, num_groups, total_children;
  //struct timeval start, stop, diff;
  unsigned long long start=0, stop=0, diff=0;
 4e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 4ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 4fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 504:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 50b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  // NOTE: More than 8 causes error due to num of fds.
  unsigned int num_fds = NUM_FDS;  // Original this is 20
 512:	c7 45 d4 08 00 00 00 	movl   $0x8,-0x2c(%ebp)
    use_pipes = 1;
    argc--;
    argv++;
    }
  */
  use_pipes = 1;
 519:	c7 05 68 13 00 00 01 	movl   $0x1,0x1368
 520:	00 00 00 
  argc--;
 523:	83 28 01             	subl   $0x1,(%eax)
  argv++;
 526:	83 40 04 04          	addl   $0x4,0x4(%eax)

  //if (argc != 2 || (num_groups = atoi(argv[1])) == 0)
  //        barf("Usage: hackbench [-pipe] <num groups>\n");

  // NOTE: More than 3 causes error due to num of processes.
  num_groups = NUM_GROUPS; // TODO: This may seriously be considered.
 52a:	c7 45 d0 02 00 00 00 	movl   $0x2,-0x30(%ebp)

  fdpair(readyfds);
 531:	83 ec 0c             	sub    $0xc,%esp
 534:	8d 45 c8             	lea    -0x38(%ebp),%eax
 537:	50                   	push   %eax
 538:	e8 f9 fa ff ff       	call   36 <fdpair>
 53d:	83 c4 10             	add    $0x10,%esp
  fdpair(wakefds);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	8d 45 c0             	lea    -0x40(%ebp),%eax
 546:	50                   	push   %eax
 547:	e8 ea fa ff ff       	call   36 <fdpair>
 54c:	83 c4 10             	add    $0x10,%esp

  total_children = 0;
 54f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (i = 0; i < num_groups; i++)
 556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 55d:	eb 1d                	jmp    57c <main+0xa7>
    total_children += group(num_fds, readyfds[1], wakefds[0]);
 55f:	8b 55 c0             	mov    -0x40(%ebp),%edx
 562:	8b 45 cc             	mov    -0x34(%ebp),%eax
 565:	83 ec 04             	sub    $0x4,%esp
 568:	52                   	push   %edx
 569:	50                   	push   %eax
 56a:	ff 75 d4             	pushl  -0x2c(%ebp)
 56d:	e8 d9 fd ff ff       	call   34b <group>
 572:	83 c4 10             	add    $0x10,%esp
 575:	01 45 f0             	add    %eax,-0x10(%ebp)
  for (i = 0; i < num_groups; i++)
 578:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 582:	72 db                	jb     55f <main+0x8a>

  /* Wait for everyone to be ready */
  for (i = 0; i < total_children; i++)
 584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 58b:	eb 2e                	jmp    5bb <main+0xe6>
    if (read(readyfds[0], &dummy, 1) != 1)
 58d:	8b 45 c8             	mov    -0x38(%ebp),%eax
 590:	83 ec 04             	sub    $0x4,%esp
 593:	6a 01                	push   $0x1
 595:	8d 55 bf             	lea    -0x41(%ebp),%edx
 598:	52                   	push   %edx
 599:	50                   	push   %eax
 59a:	e8 19 03 00 00       	call   8b8 <read>
 59f:	83 c4 10             	add    $0x10,%esp
 5a2:	83 f8 01             	cmp    $0x1,%eax
 5a5:	74 10                	je     5b7 <main+0xe2>
      barf("Reading for readyfds");
 5a7:	83 ec 0c             	sub    $0xc,%esp
 5aa:	68 b1 0f 00 00       	push   $0xfb1
 5af:	e8 62 fa ff ff       	call   16 <barf>
 5b4:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < total_children; i++)
 5b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 5c1:	72 ca                	jb     58d <main+0xb8>

  //gettimeofday(&start, NULL);
  start = rdtsc();
 5c3:	e8 38 fa ff ff       	call   0 <rdtsc>
 5c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 5cb:	89 55 ec             	mov    %edx,-0x14(%ebp)
  if(DEBUG) printf(STDOUT, "Start Watching Time ...\n");
  

  /* Kick them off */
  if (write(wakefds[1], &dummy, 1) != 1)
 5ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5d1:	83 ec 04             	sub    $0x4,%esp
 5d4:	6a 01                	push   $0x1
 5d6:	8d 55 bf             	lea    -0x41(%ebp),%edx
 5d9:	52                   	push   %edx
 5da:	50                   	push   %eax
 5db:	e8 e0 02 00 00       	call   8c0 <write>
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	83 f8 01             	cmp    $0x1,%eax
 5e6:	74 10                	je     5f8 <main+0x123>
    barf("Writing to start them");
 5e8:	83 ec 0c             	sub    $0xc,%esp
 5eb:	68 c6 0f 00 00       	push   $0xfc6
 5f0:	e8 21 fa ff ff       	call   16 <barf>
 5f5:	83 c4 10             	add    $0x10,%esp

  /* Reap them all */
  //TODO: Fix different specifications between xv6 and Linux
  for (i = 0; i < total_children; i++) {
 5f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5ff:	eb 09                	jmp    60a <main+0x135>
    //int status;
    //wait(&status); // TODO: Too Many Arguments???
    wait(); // Waiting for that all child's tasks finish.
 601:	e8 a2 02 00 00       	call   8a8 <wait>
  for (i = 0; i < total_children; i++) {
 606:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 610:	72 ef                	jb     601 <main+0x12c>
    // TODO: What's WIFEXITED ???
    //if (!WIFEXITED(status))
    //  exit();
  }
  
  stop = rdtsc();
 612:	e8 e9 f9 ff ff       	call   0 <rdtsc>
 617:	89 45 e0             	mov    %eax,-0x20(%ebp)
 61a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if(DEBUG) printf(STDOUT, "Stop Watching Time ...\n");
  diff = stop - start;
 61d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 623:	2b 45 e8             	sub    -0x18(%ebp),%eax
 626:	1b 55 ec             	sbb    -0x14(%ebp),%edx
 629:	89 45 d8             	mov    %eax,-0x28(%ebp)
 62c:	89 55 dc             	mov    %edx,-0x24(%ebp)

  /* Print time... */
  printf(STDOUT, "Time: 0x%l [ticks]\n", diff);
 62f:	ff 75 dc             	pushl  -0x24(%ebp)
 632:	ff 75 d8             	pushl  -0x28(%ebp)
 635:	68 dc 0f 00 00       	push   $0xfdc
 63a:	6a 01                	push   $0x1
 63c:	e8 3a 04 00 00       	call   a7b <printf>
 641:	83 c4 10             	add    $0x10,%esp
  if(DEBUG) printf(STDOUT, "fd_count = %d\n", fd_count);
  exit();
 644:	e8 57 02 00 00       	call   8a0 <exit>

00000649 <stosb>:
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	57                   	push   %edi
 64d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 64e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 651:	8b 55 10             	mov    0x10(%ebp),%edx
 654:	8b 45 0c             	mov    0xc(%ebp),%eax
 657:	89 cb                	mov    %ecx,%ebx
 659:	89 df                	mov    %ebx,%edi
 65b:	89 d1                	mov    %edx,%ecx
 65d:	fc                   	cld    
 65e:	f3 aa                	rep stos %al,%es:(%edi)
 660:	89 ca                	mov    %ecx,%edx
 662:	89 fb                	mov    %edi,%ebx
 664:	89 5d 08             	mov    %ebx,0x8(%ebp)
 667:	89 55 10             	mov    %edx,0x10(%ebp)
}
 66a:	90                   	nop
 66b:	5b                   	pop    %ebx
 66c:	5f                   	pop    %edi
 66d:	5d                   	pop    %ebp
 66e:	c3                   	ret    

0000066f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 66f:	55                   	push   %ebp
 670:	89 e5                	mov    %esp,%ebp
 672:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 67b:	90                   	nop
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	8d 50 01             	lea    0x1(%eax),%edx
 682:	89 55 08             	mov    %edx,0x8(%ebp)
 685:	8b 55 0c             	mov    0xc(%ebp),%edx
 688:	8d 4a 01             	lea    0x1(%edx),%ecx
 68b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 68e:	0f b6 12             	movzbl (%edx),%edx
 691:	88 10                	mov    %dl,(%eax)
 693:	0f b6 00             	movzbl (%eax),%eax
 696:	84 c0                	test   %al,%al
 698:	75 e2                	jne    67c <strcpy+0xd>
    ;
  return os;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 69d:	c9                   	leave  
 69e:	c3                   	ret    

0000069f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 6a2:	eb 08                	jmp    6ac <strcmp+0xd>
    p++, q++;
 6a4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	0f b6 00             	movzbl (%eax),%eax
 6b2:	84 c0                	test   %al,%al
 6b4:	74 10                	je     6c6 <strcmp+0x27>
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	0f b6 10             	movzbl (%eax),%edx
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	38 c2                	cmp    %al,%dl
 6c4:	74 de                	je     6a4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 6c6:	8b 45 08             	mov    0x8(%ebp),%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	0f b6 d0             	movzbl %al,%edx
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	0f b6 00             	movzbl (%eax),%eax
 6d5:	0f b6 c0             	movzbl %al,%eax
 6d8:	29 c2                	sub    %eax,%edx
 6da:	89 d0                	mov    %edx,%eax
}
 6dc:	5d                   	pop    %ebp
 6dd:	c3                   	ret    

000006de <strlen>:

uint
strlen(char *s)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
 6e1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6eb:	eb 04                	jmp    6f1 <strlen+0x13>
 6ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	84 c0                	test   %al,%al
 6fe:	75 ed                	jne    6ed <strlen+0xf>
    ;
  return n;
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 703:	c9                   	leave  
 704:	c3                   	ret    

00000705 <memset>:

void*
memset(void *dst, int c, uint n)
{
 705:	55                   	push   %ebp
 706:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 708:	8b 45 10             	mov    0x10(%ebp),%eax
 70b:	50                   	push   %eax
 70c:	ff 75 0c             	pushl  0xc(%ebp)
 70f:	ff 75 08             	pushl  0x8(%ebp)
 712:	e8 32 ff ff ff       	call   649 <stosb>
 717:	83 c4 0c             	add    $0xc,%esp
  return dst;
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 71d:	c9                   	leave  
 71e:	c3                   	ret    

0000071f <strchr>:

char*
strchr(const char *s, char c)
{
 71f:	55                   	push   %ebp
 720:	89 e5                	mov    %esp,%ebp
 722:	83 ec 04             	sub    $0x4,%esp
 725:	8b 45 0c             	mov    0xc(%ebp),%eax
 728:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 72b:	eb 14                	jmp    741 <strchr+0x22>
    if(*s == c)
 72d:	8b 45 08             	mov    0x8(%ebp),%eax
 730:	0f b6 00             	movzbl (%eax),%eax
 733:	3a 45 fc             	cmp    -0x4(%ebp),%al
 736:	75 05                	jne    73d <strchr+0x1e>
      return (char*)s;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	eb 13                	jmp    750 <strchr+0x31>
  for(; *s; s++)
 73d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 741:	8b 45 08             	mov    0x8(%ebp),%eax
 744:	0f b6 00             	movzbl (%eax),%eax
 747:	84 c0                	test   %al,%al
 749:	75 e2                	jne    72d <strchr+0xe>
  return 0;
 74b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 750:	c9                   	leave  
 751:	c3                   	ret    

00000752 <gets>:

char*
gets(char *buf, int max)
{
 752:	55                   	push   %ebp
 753:	89 e5                	mov    %esp,%ebp
 755:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 758:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 75f:	eb 42                	jmp    7a3 <gets+0x51>
    cc = read(0, &c, 1);
 761:	83 ec 04             	sub    $0x4,%esp
 764:	6a 01                	push   $0x1
 766:	8d 45 ef             	lea    -0x11(%ebp),%eax
 769:	50                   	push   %eax
 76a:	6a 00                	push   $0x0
 76c:	e8 47 01 00 00       	call   8b8 <read>
 771:	83 c4 10             	add    $0x10,%esp
 774:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 777:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77b:	7e 33                	jle    7b0 <gets+0x5e>
      break;
    buf[i++] = c;
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8d 50 01             	lea    0x1(%eax),%edx
 783:	89 55 f4             	mov    %edx,-0xc(%ebp)
 786:	89 c2                	mov    %eax,%edx
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	01 c2                	add    %eax,%edx
 78d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 791:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 793:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 797:	3c 0a                	cmp    $0xa,%al
 799:	74 16                	je     7b1 <gets+0x5f>
 79b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 79f:	3c 0d                	cmp    $0xd,%al
 7a1:	74 0e                	je     7b1 <gets+0x5f>
  for(i=0; i+1 < max; ){
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	83 c0 01             	add    $0x1,%eax
 7a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7ac:	7c b3                	jl     761 <gets+0xf>
 7ae:	eb 01                	jmp    7b1 <gets+0x5f>
      break;
 7b0:	90                   	nop
      break;
  }
  buf[i] = '\0';
 7b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7bf:	c9                   	leave  
 7c0:	c3                   	ret    

000007c1 <stat>:

int
stat(char *n, struct stat *st)
{
 7c1:	55                   	push   %ebp
 7c2:	89 e5                	mov    %esp,%ebp
 7c4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7c7:	83 ec 08             	sub    $0x8,%esp
 7ca:	6a 00                	push   $0x0
 7cc:	ff 75 08             	pushl  0x8(%ebp)
 7cf:	e8 0c 01 00 00       	call   8e0 <open>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7de:	79 07                	jns    7e7 <stat+0x26>
    return -1;
 7e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7e5:	eb 25                	jmp    80c <stat+0x4b>
  r = fstat(fd, st);
 7e7:	83 ec 08             	sub    $0x8,%esp
 7ea:	ff 75 0c             	pushl  0xc(%ebp)
 7ed:	ff 75 f4             	pushl  -0xc(%ebp)
 7f0:	e8 03 01 00 00       	call   8f8 <fstat>
 7f5:	83 c4 10             	add    $0x10,%esp
 7f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	ff 75 f4             	pushl  -0xc(%ebp)
 801:	e8 c2 00 00 00       	call   8c8 <close>
 806:	83 c4 10             	add    $0x10,%esp
  return r;
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    

0000080e <atoi>:

int
atoi(const char *s)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 814:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 81b:	eb 25                	jmp    842 <atoi+0x34>
    n = n*10 + *s++ - '0';
 81d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 820:	89 d0                	mov    %edx,%eax
 822:	c1 e0 02             	shl    $0x2,%eax
 825:	01 d0                	add    %edx,%eax
 827:	01 c0                	add    %eax,%eax
 829:	89 c1                	mov    %eax,%ecx
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	8d 50 01             	lea    0x1(%eax),%edx
 831:	89 55 08             	mov    %edx,0x8(%ebp)
 834:	0f b6 00             	movzbl (%eax),%eax
 837:	0f be c0             	movsbl %al,%eax
 83a:	01 c8                	add    %ecx,%eax
 83c:	83 e8 30             	sub    $0x30,%eax
 83f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 842:	8b 45 08             	mov    0x8(%ebp),%eax
 845:	0f b6 00             	movzbl (%eax),%eax
 848:	3c 2f                	cmp    $0x2f,%al
 84a:	7e 0a                	jle    856 <atoi+0x48>
 84c:	8b 45 08             	mov    0x8(%ebp),%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	3c 39                	cmp    $0x39,%al
 854:	7e c7                	jle    81d <atoi+0xf>
  return n;
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 861:	8b 45 08             	mov    0x8(%ebp),%eax
 864:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 867:	8b 45 0c             	mov    0xc(%ebp),%eax
 86a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 86d:	eb 17                	jmp    886 <memmove+0x2b>
    *dst++ = *src++;
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8d 50 01             	lea    0x1(%eax),%edx
 875:	89 55 fc             	mov    %edx,-0x4(%ebp)
 878:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87b:	8d 4a 01             	lea    0x1(%edx),%ecx
 87e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 881:	0f b6 12             	movzbl (%edx),%edx
 884:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 886:	8b 45 10             	mov    0x10(%ebp),%eax
 889:	8d 50 ff             	lea    -0x1(%eax),%edx
 88c:	89 55 10             	mov    %edx,0x10(%ebp)
 88f:	85 c0                	test   %eax,%eax
 891:	7f dc                	jg     86f <memmove+0x14>
  return vdst;
 893:	8b 45 08             	mov    0x8(%ebp),%eax
}
 896:	c9                   	leave  
 897:	c3                   	ret    

00000898 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 898:	b8 01 00 00 00       	mov    $0x1,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <exit>:
SYSCALL(exit)
 8a0:	b8 02 00 00 00       	mov    $0x2,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <wait>:
SYSCALL(wait)
 8a8:	b8 03 00 00 00       	mov    $0x3,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <pipe>:
SYSCALL(pipe)
 8b0:	b8 04 00 00 00       	mov    $0x4,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <read>:
SYSCALL(read)
 8b8:	b8 05 00 00 00       	mov    $0x5,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <write>:
SYSCALL(write)
 8c0:	b8 10 00 00 00       	mov    $0x10,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <close>:
SYSCALL(close)
 8c8:	b8 15 00 00 00       	mov    $0x15,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <kill>:
SYSCALL(kill)
 8d0:	b8 06 00 00 00       	mov    $0x6,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <exec>:
SYSCALL(exec)
 8d8:	b8 07 00 00 00       	mov    $0x7,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <open>:
SYSCALL(open)
 8e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <mknod>:
SYSCALL(mknod)
 8e8:	b8 11 00 00 00       	mov    $0x11,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <unlink>:
SYSCALL(unlink)
 8f0:	b8 12 00 00 00       	mov    $0x12,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <fstat>:
SYSCALL(fstat)
 8f8:	b8 08 00 00 00       	mov    $0x8,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <link>:
SYSCALL(link)
 900:	b8 13 00 00 00       	mov    $0x13,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <mkdir>:
SYSCALL(mkdir)
 908:	b8 14 00 00 00       	mov    $0x14,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <chdir>:
SYSCALL(chdir)
 910:	b8 09 00 00 00       	mov    $0x9,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <dup>:
SYSCALL(dup)
 918:	b8 0a 00 00 00       	mov    $0xa,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <getpid>:
SYSCALL(getpid)
 920:	b8 0b 00 00 00       	mov    $0xb,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <sbrk>:
SYSCALL(sbrk)
 928:	b8 0c 00 00 00       	mov    $0xc,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <sleep>:
SYSCALL(sleep)
 930:	b8 0d 00 00 00       	mov    $0xd,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <uptime>:
SYSCALL(uptime)
 938:	b8 0e 00 00 00       	mov    $0xe,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <gettime>:
SYSCALL(gettime)
 940:	b8 16 00 00 00       	mov    $0x16,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <settickets>:
SYSCALL(settickets)
 948:	b8 17 00 00 00       	mov    $0x17,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	83 ec 18             	sub    $0x18,%esp
 956:	8b 45 0c             	mov    0xc(%ebp),%eax
 959:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 95c:	83 ec 04             	sub    $0x4,%esp
 95f:	6a 01                	push   $0x1
 961:	8d 45 f4             	lea    -0xc(%ebp),%eax
 964:	50                   	push   %eax
 965:	ff 75 08             	pushl  0x8(%ebp)
 968:	e8 53 ff ff ff       	call   8c0 <write>
 96d:	83 c4 10             	add    $0x10,%esp
}
 970:	90                   	nop
 971:	c9                   	leave  
 972:	c3                   	ret    

00000973 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 973:	55                   	push   %ebp
 974:	89 e5                	mov    %esp,%ebp
 976:	53                   	push   %ebx
 977:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 97a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 981:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 985:	74 17                	je     99e <printint+0x2b>
 987:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 98b:	79 11                	jns    99e <printint+0x2b>
    neg = 1;
 98d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 994:	8b 45 0c             	mov    0xc(%ebp),%eax
 997:	f7 d8                	neg    %eax
 999:	89 45 ec             	mov    %eax,-0x14(%ebp)
 99c:	eb 06                	jmp    9a4 <printint+0x31>
  } else {
    x = xx;
 99e:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9ae:	8d 41 01             	lea    0x1(%ecx),%eax
 9b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ba:	ba 00 00 00 00       	mov    $0x0,%edx
 9bf:	f7 f3                	div    %ebx
 9c1:	89 d0                	mov    %edx,%eax
 9c3:	0f b6 80 6c 13 00 00 	movzbl 0x136c(%eax),%eax
 9ca:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d4:	ba 00 00 00 00       	mov    $0x0,%edx
 9d9:	f7 f3                	div    %ebx
 9db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9e2:	75 c7                	jne    9ab <printint+0x38>
  if(neg)
 9e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9e8:	74 2d                	je     a17 <printint+0xa4>
    buf[i++] = '-';
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	8d 50 01             	lea    0x1(%eax),%edx
 9f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9f3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9f8:	eb 1d                	jmp    a17 <printint+0xa4>
    putc(fd, buf[i]);
 9fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a00:	01 d0                	add    %edx,%eax
 a02:	0f b6 00             	movzbl (%eax),%eax
 a05:	0f be c0             	movsbl %al,%eax
 a08:	83 ec 08             	sub    $0x8,%esp
 a0b:	50                   	push   %eax
 a0c:	ff 75 08             	pushl  0x8(%ebp)
 a0f:	e8 3c ff ff ff       	call   950 <putc>
 a14:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 a17:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a1f:	79 d9                	jns    9fa <printint+0x87>
}
 a21:	90                   	nop
 a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a25:	c9                   	leave  
 a26:	c3                   	ret    

00000a27 <printlong>:

static void
printlong(int fd, unsigned long long xx, int base, int sgn)
{
 a27:	55                   	push   %ebp
 a28:	89 e5                	mov    %esp,%ebp
 a2a:	83 ec 28             	sub    $0x28,%esp
 a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
 a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
 a33:	8b 45 10             	mov    0x10(%ebp),%eax
 a36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    // Force hexadecimal
    uint upper, lower;
    upper = xx >> 32;
 a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a3f:	89 d0                	mov    %edx,%eax
 a41:	31 d2                	xor    %edx,%edx
 a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lower = xx & 0xffffffff;
 a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
 a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(upper) printint(fd, upper, 16, 0);
 a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a50:	74 13                	je     a65 <printlong+0x3e>
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	6a 00                	push   $0x0
 a57:	6a 10                	push   $0x10
 a59:	50                   	push   %eax
 a5a:	ff 75 08             	pushl  0x8(%ebp)
 a5d:	e8 11 ff ff ff       	call   973 <printint>
 a62:	83 c4 10             	add    $0x10,%esp
    printint(fd, lower, 16, 0);
 a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a68:	6a 00                	push   $0x0
 a6a:	6a 10                	push   $0x10
 a6c:	50                   	push   %eax
 a6d:	ff 75 08             	pushl  0x8(%ebp)
 a70:	e8 fe fe ff ff       	call   973 <printint>
 a75:	83 c4 10             	add    $0x10,%esp
}
 a78:	90                   	nop
 a79:	c9                   	leave  
 a7a:	c3                   	ret    

00000a7b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
// bdg 10/05/2015: Add %l
void
printf(int fd, char *fmt, ...)
{
 a7b:	55                   	push   %ebp
 a7c:	89 e5                	mov    %esp,%ebp
 a7e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a88:	8d 45 0c             	lea    0xc(%ebp),%eax
 a8b:	83 c0 04             	add    $0x4,%eax
 a8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a98:	e9 88 01 00 00       	jmp    c25 <printf+0x1aa>
    c = fmt[i] & 0xff;
 a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
 aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa3:	01 d0                	add    %edx,%eax
 aa5:	0f b6 00             	movzbl (%eax),%eax
 aa8:	0f be c0             	movsbl %al,%eax
 aab:	25 ff 00 00 00       	and    $0xff,%eax
 ab0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ab3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ab7:	75 2c                	jne    ae5 <printf+0x6a>
      if(c == '%'){
 ab9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 abd:	75 0c                	jne    acb <printf+0x50>
        state = '%';
 abf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ac6:	e9 56 01 00 00       	jmp    c21 <printf+0x1a6>
      } else {
        putc(fd, c);
 acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ace:	0f be c0             	movsbl %al,%eax
 ad1:	83 ec 08             	sub    $0x8,%esp
 ad4:	50                   	push   %eax
 ad5:	ff 75 08             	pushl  0x8(%ebp)
 ad8:	e8 73 fe ff ff       	call   950 <putc>
 add:	83 c4 10             	add    $0x10,%esp
 ae0:	e9 3c 01 00 00       	jmp    c21 <printf+0x1a6>
      }
    } else if(state == '%'){
 ae5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 ae9:	0f 85 32 01 00 00    	jne    c21 <printf+0x1a6>
      if(c == 'd'){
 aef:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 af3:	75 1e                	jne    b13 <printf+0x98>
        printint(fd, *ap, 10, 1);
 af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 af8:	8b 00                	mov    (%eax),%eax
 afa:	6a 01                	push   $0x1
 afc:	6a 0a                	push   $0xa
 afe:	50                   	push   %eax
 aff:	ff 75 08             	pushl  0x8(%ebp)
 b02:	e8 6c fe ff ff       	call   973 <printint>
 b07:	83 c4 10             	add    $0x10,%esp
        ap++;
 b0a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b0e:	e9 07 01 00 00       	jmp    c1a <printf+0x19f>
      } else if(c == 'l') {
 b13:	83 7d e4 6c          	cmpl   $0x6c,-0x1c(%ebp)
 b17:	75 29                	jne    b42 <printf+0xc7>
        printlong(fd, *(unsigned long long *)ap, 10, 0);
 b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b1c:	8b 50 04             	mov    0x4(%eax),%edx
 b1f:	8b 00                	mov    (%eax),%eax
 b21:	83 ec 0c             	sub    $0xc,%esp
 b24:	6a 00                	push   $0x0
 b26:	6a 0a                	push   $0xa
 b28:	52                   	push   %edx
 b29:	50                   	push   %eax
 b2a:	ff 75 08             	pushl  0x8(%ebp)
 b2d:	e8 f5 fe ff ff       	call   a27 <printlong>
 b32:	83 c4 20             	add    $0x20,%esp
        // long longs take up 2 argument slots
        ap++;
 b35:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        ap++;
 b39:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b3d:	e9 d8 00 00 00       	jmp    c1a <printf+0x19f>
      } else if(c == 'x' || c == 'p'){
 b42:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b46:	74 06                	je     b4e <printf+0xd3>
 b48:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b4c:	75 1e                	jne    b6c <printf+0xf1>
        printint(fd, *ap, 16, 0);
 b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b51:	8b 00                	mov    (%eax),%eax
 b53:	6a 00                	push   $0x0
 b55:	6a 10                	push   $0x10
 b57:	50                   	push   %eax
 b58:	ff 75 08             	pushl  0x8(%ebp)
 b5b:	e8 13 fe ff ff       	call   973 <printint>
 b60:	83 c4 10             	add    $0x10,%esp
        ap++;
 b63:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b67:	e9 ae 00 00 00       	jmp    c1a <printf+0x19f>
      } else if(c == 's'){
 b6c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b70:	75 43                	jne    bb5 <printf+0x13a>
        s = (char*)*ap;
 b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b75:	8b 00                	mov    (%eax),%eax
 b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b82:	75 25                	jne    ba9 <printf+0x12e>
          s = "(null)";
 b84:	c7 45 f4 f0 0f 00 00 	movl   $0xff0,-0xc(%ebp)
        while(*s != 0){
 b8b:	eb 1c                	jmp    ba9 <printf+0x12e>
          putc(fd, *s);
 b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b90:	0f b6 00             	movzbl (%eax),%eax
 b93:	0f be c0             	movsbl %al,%eax
 b96:	83 ec 08             	sub    $0x8,%esp
 b99:	50                   	push   %eax
 b9a:	ff 75 08             	pushl  0x8(%ebp)
 b9d:	e8 ae fd ff ff       	call   950 <putc>
 ba2:	83 c4 10             	add    $0x10,%esp
          s++;
 ba5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bac:	0f b6 00             	movzbl (%eax),%eax
 baf:	84 c0                	test   %al,%al
 bb1:	75 da                	jne    b8d <printf+0x112>
 bb3:	eb 65                	jmp    c1a <printf+0x19f>
        }
      } else if(c == 'c'){
 bb5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 bb9:	75 1d                	jne    bd8 <printf+0x15d>
        putc(fd, *ap);
 bbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bbe:	8b 00                	mov    (%eax),%eax
 bc0:	0f be c0             	movsbl %al,%eax
 bc3:	83 ec 08             	sub    $0x8,%esp
 bc6:	50                   	push   %eax
 bc7:	ff 75 08             	pushl  0x8(%ebp)
 bca:	e8 81 fd ff ff       	call   950 <putc>
 bcf:	83 c4 10             	add    $0x10,%esp
        ap++;
 bd2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bd6:	eb 42                	jmp    c1a <printf+0x19f>
      } else if(c == '%'){
 bd8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bdc:	75 17                	jne    bf5 <printf+0x17a>
        putc(fd, c);
 bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 be1:	0f be c0             	movsbl %al,%eax
 be4:	83 ec 08             	sub    $0x8,%esp
 be7:	50                   	push   %eax
 be8:	ff 75 08             	pushl  0x8(%ebp)
 beb:	e8 60 fd ff ff       	call   950 <putc>
 bf0:	83 c4 10             	add    $0x10,%esp
 bf3:	eb 25                	jmp    c1a <printf+0x19f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bf5:	83 ec 08             	sub    $0x8,%esp
 bf8:	6a 25                	push   $0x25
 bfa:	ff 75 08             	pushl  0x8(%ebp)
 bfd:	e8 4e fd ff ff       	call   950 <putc>
 c02:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c08:	0f be c0             	movsbl %al,%eax
 c0b:	83 ec 08             	sub    $0x8,%esp
 c0e:	50                   	push   %eax
 c0f:	ff 75 08             	pushl  0x8(%ebp)
 c12:	e8 39 fd ff ff       	call   950 <putc>
 c17:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c1a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 c21:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c25:	8b 55 0c             	mov    0xc(%ebp),%edx
 c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2b:	01 d0                	add    %edx,%eax
 c2d:	0f b6 00             	movzbl (%eax),%eax
 c30:	84 c0                	test   %al,%al
 c32:	0f 85 65 fe ff ff    	jne    a9d <printf+0x22>
    }
  }
}
 c38:	90                   	nop
 c39:	c9                   	leave  
 c3a:	c3                   	ret    

00000c3b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c3b:	55                   	push   %ebp
 c3c:	89 e5                	mov    %esp,%ebp
 c3e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c41:	8b 45 08             	mov    0x8(%ebp),%eax
 c44:	83 e8 08             	sub    $0x8,%eax
 c47:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c4a:	a1 8c 13 00 00       	mov    0x138c,%eax
 c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c52:	eb 24                	jmp    c78 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c57:	8b 00                	mov    (%eax),%eax
 c59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c5c:	77 12                	ja     c70 <free+0x35>
 c5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c61:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c64:	77 24                	ja     c8a <free+0x4f>
 c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c69:	8b 00                	mov    (%eax),%eax
 c6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c6e:	77 1a                	ja     c8a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c73:	8b 00                	mov    (%eax),%eax
 c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c7e:	76 d4                	jbe    c54 <free+0x19>
 c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c83:	8b 00                	mov    (%eax),%eax
 c85:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c88:	76 ca                	jbe    c54 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8d:	8b 40 04             	mov    0x4(%eax),%eax
 c90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9a:	01 c2                	add    %eax,%edx
 c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9f:	8b 00                	mov    (%eax),%eax
 ca1:	39 c2                	cmp    %eax,%edx
 ca3:	75 24                	jne    cc9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca8:	8b 50 04             	mov    0x4(%eax),%edx
 cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cae:	8b 00                	mov    (%eax),%eax
 cb0:	8b 40 04             	mov    0x4(%eax),%eax
 cb3:	01 c2                	add    %eax,%edx
 cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbe:	8b 00                	mov    (%eax),%eax
 cc0:	8b 10                	mov    (%eax),%edx
 cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc5:	89 10                	mov    %edx,(%eax)
 cc7:	eb 0a                	jmp    cd3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ccc:	8b 10                	mov    (%eax),%edx
 cce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd6:	8b 40 04             	mov    0x4(%eax),%eax
 cd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce3:	01 d0                	add    %edx,%eax
 ce5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ce8:	75 20                	jne    d0a <free+0xcf>
    p->s.size += bp->s.size;
 cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ced:	8b 50 04             	mov    0x4(%eax),%edx
 cf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf3:	8b 40 04             	mov    0x4(%eax),%eax
 cf6:	01 c2                	add    %eax,%edx
 cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d01:	8b 10                	mov    (%eax),%edx
 d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d06:	89 10                	mov    %edx,(%eax)
 d08:	eb 08                	jmp    d12 <free+0xd7>
  } else
    p->s.ptr = bp;
 d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d10:	89 10                	mov    %edx,(%eax)
  freep = p;
 d12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d15:	a3 8c 13 00 00       	mov    %eax,0x138c
}
 d1a:	90                   	nop
 d1b:	c9                   	leave  
 d1c:	c3                   	ret    

00000d1d <morecore>:

static Header*
morecore(uint nu)
{
 d1d:	55                   	push   %ebp
 d1e:	89 e5                	mov    %esp,%ebp
 d20:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d23:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d2a:	77 07                	ja     d33 <morecore+0x16>
    nu = 4096;
 d2c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d33:	8b 45 08             	mov    0x8(%ebp),%eax
 d36:	c1 e0 03             	shl    $0x3,%eax
 d39:	83 ec 0c             	sub    $0xc,%esp
 d3c:	50                   	push   %eax
 d3d:	e8 e6 fb ff ff       	call   928 <sbrk>
 d42:	83 c4 10             	add    $0x10,%esp
 d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d48:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d4c:	75 07                	jne    d55 <morecore+0x38>
    return 0;
 d4e:	b8 00 00 00 00       	mov    $0x0,%eax
 d53:	eb 26                	jmp    d7b <morecore+0x5e>
  hp = (Header*)p;
 d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d5e:	8b 55 08             	mov    0x8(%ebp),%edx
 d61:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d67:	83 c0 08             	add    $0x8,%eax
 d6a:	83 ec 0c             	sub    $0xc,%esp
 d6d:	50                   	push   %eax
 d6e:	e8 c8 fe ff ff       	call   c3b <free>
 d73:	83 c4 10             	add    $0x10,%esp
  return freep;
 d76:	a1 8c 13 00 00       	mov    0x138c,%eax
}
 d7b:	c9                   	leave  
 d7c:	c3                   	ret    

00000d7d <malloc>:

void*
malloc(uint nbytes)
{
 d7d:	55                   	push   %ebp
 d7e:	89 e5                	mov    %esp,%ebp
 d80:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d83:	8b 45 08             	mov    0x8(%ebp),%eax
 d86:	83 c0 07             	add    $0x7,%eax
 d89:	c1 e8 03             	shr    $0x3,%eax
 d8c:	83 c0 01             	add    $0x1,%eax
 d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d92:	a1 8c 13 00 00       	mov    0x138c,%eax
 d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d9e:	75 23                	jne    dc3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 da0:	c7 45 f0 84 13 00 00 	movl   $0x1384,-0x10(%ebp)
 da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 daa:	a3 8c 13 00 00       	mov    %eax,0x138c
 daf:	a1 8c 13 00 00       	mov    0x138c,%eax
 db4:	a3 84 13 00 00       	mov    %eax,0x1384
    base.s.size = 0;
 db9:	c7 05 88 13 00 00 00 	movl   $0x0,0x1388
 dc0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc6:	8b 00                	mov    (%eax),%eax
 dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dce:	8b 40 04             	mov    0x4(%eax),%eax
 dd1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dd4:	72 4d                	jb     e23 <malloc+0xa6>
      if(p->s.size == nunits)
 dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd9:	8b 40 04             	mov    0x4(%eax),%eax
 ddc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ddf:	75 0c                	jne    ded <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de4:	8b 10                	mov    (%eax),%edx
 de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de9:	89 10                	mov    %edx,(%eax)
 deb:	eb 26                	jmp    e13 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df0:	8b 40 04             	mov    0x4(%eax),%eax
 df3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 df6:	89 c2                	mov    %eax,%edx
 df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dfb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e01:	8b 40 04             	mov    0x4(%eax),%eax
 e04:	c1 e0 03             	shl    $0x3,%eax
 e07:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e10:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e16:	a3 8c 13 00 00       	mov    %eax,0x138c
      return (void*)(p + 1);
 e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1e:	83 c0 08             	add    $0x8,%eax
 e21:	eb 3b                	jmp    e5e <malloc+0xe1>
    }
    if(p == freep)
 e23:	a1 8c 13 00 00       	mov    0x138c,%eax
 e28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e2b:	75 1e                	jne    e4b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 e2d:	83 ec 0c             	sub    $0xc,%esp
 e30:	ff 75 ec             	pushl  -0x14(%ebp)
 e33:	e8 e5 fe ff ff       	call   d1d <morecore>
 e38:	83 c4 10             	add    $0x10,%esp
 e3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e42:	75 07                	jne    e4b <malloc+0xce>
        return 0;
 e44:	b8 00 00 00 00       	mov    $0x0,%eax
 e49:	eb 13                	jmp    e5e <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e54:	8b 00                	mov    (%eax),%eax
 e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e59:	e9 6d ff ff ff       	jmp    dcb <malloc+0x4e>
  }
}
 e5e:	c9                   	leave  
 e5f:	c3                   	ret    
