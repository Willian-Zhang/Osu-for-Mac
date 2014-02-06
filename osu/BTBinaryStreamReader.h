//
//  BTBinaryStreamReader.h
//  Osu for Mac!
//
//  Modified by Willian on 14-2-5.
//  Copyright (c) 2014年 Willian-Zhang. All possible rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBinaryStreamReader : NSObject

@property (nonatomic, readonly, retain) NSInputStream* inputStream;

-(id)initWithStream:(NSInputStream*)inputStream andSourceByteOrder:(CFByteOrder)streamByteOrder;
-(id)initWithData:(NSData*)data andSourceByteOrder:(CFByteOrder)streamByteOrder;

-(NSError*)lastError;

-(int8_t)readInt8;
-(uint8_t)readUInt8;

-(int16_t)readInt16;
-(uint16_t)readUInt16;

-(int32_t)readInt32;
-(uint32_t)readUInt32;

-(int64_t)readInt64;
-(uint64_t)readUInt64;

-(float)readFloat;
-(double)readDouble;

-(NSData*)readDataOfLength:(NSUInteger)bytesToRead;

/**
 Read a string with a given encoding and a given byte size.
 
 @warning The endianness of the reader is ignored when reading strings. If the string was encoded
 in an endianness-dependant encoding but does not have a BOM, you should specify the endianness
 as part of the encoding, e.g. NSUTF16BigEndianStringEncoding.
 */
-(NSString*)readStringWithEncoding:(NSStringEncoding)stringEncoding andLength:(NSUInteger)bytesToRead;
- (NSString *)readStringByWillian;
- (NSDate *)readDateByInt64;
- (NSDate *)readDateByInt32;

@end
